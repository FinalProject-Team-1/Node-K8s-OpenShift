#!/bin/bash

NAMESPACE="bank-namespace"
pods=($(oc get pod -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}'))

echo "다음 파드 중 하나를 선택하세요!"
for i in "${!pods[@]}"; do
    echo "$((i + 1)). ${pods[i]}"
done

read -p "종료할 파드 번호를 입력하세요 >> " choice
if [[ $choice -ge 1 && $choice -le ${#pods[@]} ]]; then
    pod_to_delete="${pods[$((choice - 1))]}"
    oc delete pod "$pod_to_delete" --grace-period=0 --force -n $NAMESPACE
    echo "$pod_to_delete 파드가 강제로 종료되었습니다."
else
    echo "잘못된 선택입니다."
fi
