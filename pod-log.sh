#!/bin/bash

NAMESPACE="bank-namespace"
pods=($(oc get pod -n $NAMESPACE -o jsonpath='{.items[*].metadata.name}'))

echo "다음 파드 중 하나를 선택하세요!"
for i in "${!pods[@]}"; do
    echo "$((i + 1)). ${pods[i]}"
done

read -p "로그를 확인할 파드 번호를 입력하세요 >> " choice

if [[ $choice =~ ^[0-9]+ ]]; then
    if [[ $choice -ge 1 && $choice -le ${#pods[@]} ]]; then
        pod_to_log="${pods[$((choice - 1))]}"
        
        # -f 옵션 안내
        read -p "로그를 실시간으로 보려면 '-f'를 입력하세요. 로그를 출력하고 싶다면 아무 키나 누르세요 >> " follow_option
        
        if [[ "$follow_option" == "-f" ]]; then
            oc logs -f -n $NAMESPACE "$pod_to_log"
        else
            oc logs -n $NAMESPACE "$pod_to_log"
        fi
        
    else
        echo "잘못된 선택입니다."
    fi
else
    echo "잘못된 입력입니다."
fi
