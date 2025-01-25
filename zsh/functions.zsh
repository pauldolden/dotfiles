FZF_DEPTH=3

# Project Finder
fp() {
  cd $(find ~/Development -type d -maxdepth $FZF_DEPTH -mindepth $FZF_DEPTH | fzf)
}

function dbp() {
  case $1 in
    dev)
      PORT=5000
      ;;
    uat)
      PORT=5001
      ;;
    prod)
      PORT=5002
      ;;
    *)
      echo "Unknown stage"
      return 1
      ;;
  esac
  ~/cloud_sql_proxy -instances=the-fa-api-"$1":europe-west2:pps=tcp:"$PORT"
}

function dbppg() {
  ~/cloud_sql_proxy -instances=the-fa-sandbox:europe-west2:helix=tcp:5000
}

function twf() {
    local workflow_file=$1
    shift

    if [[ "$workflow_file" == -* ]]; then
        # If the first argument is an option, use the default .env and treat all arguments as options
        act --container-architecture linux/amd64 --secret-file .env.secrets --env-file .env.vars "$@"
    else
        # If the first argument is not an option, treat it as the workflow file
        act --container-architecture linux/amd64 --secret-file .env.secrets --var-file .env.vars "$@" -W ".github/workflows/${workflow_file}"
    fi
}

function kp() {
  kill -9 $(lsof -ti :"$1")
}

function get_pod_logs() {
  if [ -z "$1" ]; then
    echo "Please provide a pod name filter."
    return 1
  fi

  pod_filter=$1
  kubectl get pods -n helix-obs | grep "$pod_filter" | awk '{print $1}' | xargs -I {} kubectl logs -n helix-obs {}
}

