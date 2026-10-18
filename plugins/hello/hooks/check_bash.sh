#!/bin/bash

MAX_RETRY=3
CURRENT_RETRY=0

while true
  do
    echo "开始执行测试..."

    # 实际执行测试脚本
    LOG=$(bash start_test.sh 2>&1)

    # 提取失败数量
    FAIL=$(echo "${LOG}" | grep -oE '失败[[:space:]]*[0-9]+' | grep -oE '[0-9]+' | tail -1)

    # 未解析到失败数量，不应该误判为通过
    if [ -z "${FAIL}" ];then
        echo "解析测试失败数量失败，请检查测试日志"
        exit 1
    fi

    # 测试通过
    if [ "${FAIL}" -eq 0 ];then
      echo "测试通过，退出"
      exit 0
    fi

    CURRENT_RETRY=$((CURRENT_RETRY+1))
    echo "测试失败，失败数量为:${FAIL},当前次数/最大尝试次数${CURRENT_RETRY}/${MAX_RETRY}"

    if [ "${CURRENT_RETRY}" -gt "${MAX_RETRY}"  ];then
      echo "连续失败：${MAX_RETRY}，需要人工介入"
      exit 2
    fi
  done