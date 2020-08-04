if [ ! -z "$TRAVIS_TAG" ]
then
    echo "on a tag -> set pom.xml <version> to $TRAVIS_TAG"
    mvn --settings .travis/settings.xml org.codehaus.mojo:versions-maven-plugin:2.1:set -DnewVersion=$TRAVIS_TAG 1>/dev/null 2>/dev/null
else
    echo "not on a tag -> keep snapshot version in pom.xml"
fi


WIN32=$(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=win32.version -q -DforceStdout)
MAC64=$(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=mac64.version -q -DforceStdout)
LINUX64=$(mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=linux64.version -q -DforceStdout)

ADDITIONAL_PARAMS=""

if [ -z "$WIN32" ]
then
    ADDITIONAL_PARAMS="${ADDITIONAL_PARAMS} -Dwin32.phase.wget=none -Dwin32.phase.attach=none"
fi

if [ -z "$MAC64" ]
then
    ADDITIONAL_PARAMS="${ADDITIONAL_PARAMS} -Dmac64.phase.wget=none -Dmac64.phase.attach=none"
fi

if [ -z "$LINUX64" ]
then
    ADDITIONAL_PARAMS="$ADDITIONAL_PARAMS -Dlinux64.phase.wget=none -Dlinux64.phase.attach=none"
fi

cmd=( "mvn clean deploy --settings .travis/settings.xml -DskipTests=true $ADDITIONAL_PARAMS -Drelease=true -B -U" )
$cmd