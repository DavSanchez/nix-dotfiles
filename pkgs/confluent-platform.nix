{ stdenv
, lib
, fetchurl
, jdk
, makeWrapper
, bash
, ps
, gnused
}:

stdenv.mkDerivation rec {
  pname = "confluent-platform";
  version = "7.3.1";

  src = fetchurl {
    url = "http://packages.confluent.io/archive/${lib.versions.majorMinor version}/confluent-${version}.tar.gz";
    sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk bash ps ];

  dontFixup = true;

  installPhase = ''
    HUB_COMPONENTS_DIR=$out/share/confluent-hub-components
	mkdir -p $HUB_COMPONENTS_DIR
    bin/confluent-hub install --no-prompt --component-dir $HUB_COMPONENTS_DIR confluentinc/kafka-connect-aws-lambda:1.1.2
    bin/confluent-hub install --no-prompt --component-dir $HUB_COMPONENTS_DIR jcustenborder/kafka-connect-spooldir:2.0.62

    mkdir -p $out
    cp -R * $out

    rm -rf $out/bin/windows

    # Customise and fix the configuration.
    substituteInPlace $out/etc/kafka/server.properties \
      --replace "#advertised.listeners=PLAINTEXT://your.host.name:9092" \
                 "advertised.listeners=PLAINTEXT://localhost:9092" \
      --replace "log.retention.hours=168" \
                "log.retention.hours=-1"

    echo >> $out/etc/ksqldb/ksql-server.properties
    echo 'ksql.streams.replication.factor = 1' >> $out/etc/ksqldb/ksql-server.properties
    echo 'ksql.query.pull.table.scan.enabled=true' >> $out/etc/ksqldb/ksql-server.properties
    echo 'ksql.extension.dir = /Users/kjenkins/Work/Confluent/jenkins-udfs/extensions/' >> $out/etc/ksqldb/ksql-server.properties

    substituteInPlace $out/etc/ksqldb/ksql-server.properties \
      --replace "# ksql.schema.registry.url=http://localhost:8081" \
                  "ksql.schema.registry.url=http://localhost:8081"

    patchShebangs $out/bin

    # allow us the specify logging directory using env
    substituteInPlace $out/bin/kafka-run-class \
      --replace 'LOG_DIR="$base_dir/logs"' 'LOG_DIR="$KAFKA_LOG_DIR"'

    substituteInPlace $out/bin/ksql-run-class \
      --replace 'LOG_DIR="$base_dir/logs"' 'LOG_DIR="$KAFKA_LOG_DIR"'


    # Handled in a separate nix recipe.
    rm $out/bin/confluent

    for p in $out/bin\/*; do
      wrapProgram $p \
        --set KAFKA_LOG_DIR "/tmp/apache-kafka-logs"
    done
  '';

  meta = with lib; {
    homepage = "https://www.confluent.io/";
    description = "Confluent event streaming platform based on Apache Kafka";
    license = licenses.asl20;
    maintainers = [ maintainers.offline ];
    platforms = platforms.unix;
  };
}