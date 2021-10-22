#!/bin/sh

source $(dirname $0)/../../env.sh

case "`uname`" in
    Linux)
		bin_abs_path=$(readlink -f $(dirname $0))
		;;
	*)
		bin_abs_path=`cd $(dirname $0); pwd`
		;;
esac
BASE=${bin_abs_path}/..

appName=springboot-demo

get_pid() {
        STR=$1
        PID=$2
        if [[ ! -z "$PID" ]]; then
                JAVA_PID=`ps -C java -f --width 1000|grep "$STR"|grep "$PID"|grep -v grep|awk '{print $2}'`
            else 
                JAVA_PID=`ps -C java -f --width 1000|grep "$STR"|grep -v grep|awk '{print $2}'`
        fi
    echo ${JAVA_PID};
}

pid=`get_pid "appName=${appName}"`
if [[ ! "$pid" = "" ]]; then
	echo "${appName} is running."
	exit -1;
fi

if [[ "$1" = "debug" ]]; then
	DEBUG_PORT=$2
	DEBUG_SUSPEND="n"
	JAVA_DEBUG_OPT="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=$DEBUG_PORT,server=y,suspend=$DEBUG_SUSPEND"
fi

JAVA_JMX_OPT=""

CURRENT=`date "+%Y%m%d%H%M%S"`

JAVA_OPTS="-Djava.io.tmpdir=${BASE}/tmp \
-DappName=${appName} \
-Djava.awt.headless=true \
-Djava.net.preferIPv4Stack=true \
-Dfile.encoding=UTF-8 \
-server \
-Xss256k \
-Xmx1G \
-Xms1G \
-Xmn512M \
-XX:+ParallelRefProcEnabled \
-XX:ErrorFile=logs/hs_err_pid%p.log \
-XX:HeapDumpPath=logs \
-XX:+HeapDumpOnOutOfMemoryError"

cd ${BASE}
if [[ ! -d "logs" ]]; then
  mkdir logs
fi
java ${JAVA_OPTS} ${JAVA_DEBUG_OPT} ${JAVA_JMX_OPT} -classpath 'lib/*:conf' com.springboot.demo.ApmDemoApplication 1>>logs/server.log 2>&1 &

echo $! > ${BASE}/server.pid

echo OK!`cat ${BASE}/server.pid`

