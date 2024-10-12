#!/bin/bash

NAMESPACE="bank-namespace"
pods=($(oc get pod -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}'))

echo "다음 파드 중 하나를 선택하세요!"
for i in "${!pods[@]}"; do
    echo "$((i + 1)). ${pods[i]}"
done

read -p "exec 할 파드 번호를 입력하세요 >> " choice

if [[ $choice =~ ^[0-9]+ ]]; then
    if [[ $choice -ge 1 && $choice -le ${#pods[@]} ]]; then
        pod_to_exec="${pods[$((choice - 1))]}"
        
        # exec 명령어 실행
        oc exec -it "$pod_to_exec" -n $NAMESPACE -- /bin/sh
        
    else
        echo "잘못된 선택입니다."
    fi
else
    echo "잘못된 입력입니다."
fi
