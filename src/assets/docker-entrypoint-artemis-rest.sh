#!/bin/sh
set -e

edit_broker() {
    xmlstarlet ed -L \
    -u "/rest-messaging/${1}" \
    -v "${2}" "${JETTY_BASE}/resources/broker.xml"
}

if [ "${USE-LINK-HEADERS}" ]; then
  edit_broker "use-link-headers" "${USE-LINK-HEADERS}"
fi

if [ "${DEFAULT_DURABLE_SEND}" ]; then
  edit_broker "default-durable-send" "${DEFAULT_DURABLE_SEND}"
fi

if [ "${DUPS_OK}" ]; then
  edit_broker "dups-ok" "${DUPS_OK}"
fi

if [ "${TOPICS_PUSH_STORE_DIR}" ]; then
  edit_broker "topic-push-store-dir" "${TOPICS_PUSH_STORE_DIR}"
fi

if [ "${QUEUE_PUSH_STORE_DIR}" ]; then
  edit_broker "queue-push-store-dir" "${QUEUE_PUSH_STORE_DIR}"
fi

if [ "${PRODUCER_TIME_TO_LIVE}" ]; then
  edit_broker "producer-time-to-live" "${PRODUCER_TIME_TO_LIVE}"
fi

if [ "${PRODUCER_SESSION_POOL_SIZE}" ]; then
  edit_broker "producer-session-pool-size" "${PRODUCER_SESSION_POOL_SIZE}"
fi

if [ "${SESSION_TIMEOUT_TASK_INTERVAL}" ]; then
  edit_broker "session-timeout-task-interval" "${SESSION_TIMEOUT_TASK_INTERVAL}"
fi

if [ "${CONSUMER_WINDOW_SIZE}" ]; then
  edit_broker "consumer-window-size" "${CONSUMER_WINDOW_SIZE}"
fi

if [ "${CONSUMER_SESSION_TIMEOUT_SECONDS}" ]; then
  edit_broker "consumer-session-timeout-seconds" "${CONSUMER_SESSION_TIMEOUT_SECONDS}"
fi

if [ "${URL}" ]; then
  edit_broker "url" "${URL}"
fi

# shellcheck disable=SC2068
exec /docker-entrypoint.sh $@
