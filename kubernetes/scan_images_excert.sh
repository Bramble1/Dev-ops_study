cat << 'EOF' > scan_images.sh
#!/bin/bash

namespace="kubernetes-dashboard"
# create a directory for the scan results
mkdir -p $namespace 

# get a list of all the images used by Pods in the Namespace
images=($(kubectl get pods -n $namespace -o jsonpath='{.items[*].spec.containers[*].image}' | sort | uniq))

# loop through the images and scan each one
for image in ${images[@]}; do
    echo "Scanning image: $image"
    # Scan the image with --scanners vuln to skip scanning for secrets to speed up the scan (for demonstration purposes)
    trivy image --severity HIGH,CRITICAL $image --scanners vuln --quiet --format json --output $namespace/$(basename $image).json
done
EOF
