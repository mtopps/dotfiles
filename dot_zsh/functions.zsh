# Terraform functions
tfa() {
  if [[ -z "$1" ]]; then
    echo "Usage: tfa <environment>"
    return 1
  fi
  terraform apply -var-file=environments/$1.tfvars
}

tfc() {
  if [[ -z "$1" ]]; then
    echo "Usage: tfc <environment>"
    return 1
  fi
  terraform console -var-file=environments/$1.tfvars
}

tpv() {
  if [[ -z "$1" ]]; then
    echo "Usage: tpv <environment>"
    return 1
  fi
  terraform plan -var-file=environments/$1.tfvars
}

tfu() {
  if [[ -z "$1" ]]; then
    echo "Usage: tfu <environment>"
    return 1
  fi
  
  # Run terraform plan to capture lock error
  output=$(terraform plan -var-file=environments/$1.tfvars 2>&1)
  
  # Extract lock ID from error message (format: │   ID:        1784412084112552)
  lock_id=$(echo "$output" | grep "ID:" | head -1 | awk -F': ' '{print $2}' | xargs)
  
  if [[ -z "$lock_id" ]]; then
    echo "Error: Could not find lock ID in terraform plan output"
    echo "Full output:"
    echo "$output"
    return 1
  fi
  
  echo "Found lock ID: $lock_id"
  echo "Forcing unlock..."
  terraform force-unlock -force "$lock_id"
}
