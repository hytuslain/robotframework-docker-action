# Start server, if any
if [ x"${START_COMMAND}" != x"" ]; then
  ${START_COMMAND} &
  SERVER_PID=$!
fi

# Create reports folder
REPORTS_DIR=$(pwd)/$ROBOT_REPORTS_DIR
TESTS_DIR=$(pwd)/$ROBOT_TESTS_DIR
sudo mkdir $REPORTS_DIR && sudo chmod 777 $REPORTS_DIR

docker run --shm-size=$ALLOWED_SHARED_MEMORY \
  -e BROWSER=$BROWSER \
  -e ROBOT_THREADS=$ROBOT_THREADS \
  -e PABOT_OPTIONS="$PABOT_OPTIONS" \
  -e ROBOT_OPTIONS="$ROBOT_OPTIONS" \
  -v $REPORTS_DIR:/opt/robotframework/reports:Z \
  -v $TESTS_DIR:/opt/robotframework/tests:Z \
  --user $(id -u):$(id -g) \
  ppodgorsek/robot-framework:latest

# Kill server if necessary
if [ x"${SERVER_PID}" != x"" ]; then
  kill $SERVER_PID
fi
