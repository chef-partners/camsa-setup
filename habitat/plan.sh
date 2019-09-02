if [ ! -f "policyfile_name" ]
then
  policy_name="server_setup"
else
  policy_name=`cat policyfile_name`
fi

scaffold_policy_name="$policy_name"
pkg_name=camsa_${policy_name}
pkg_origin=camsa
pkg_maintainer="Russell Seymour <rseymour@chef.io>"
pkg_description="CAMSA $scaffold_policy_name Policy"
pkg_upstream_url="http://chef.io"
pkg_scaffolding="chef/scaffolding-chef-infra"
pkg_svc_user=("root")
pkg_exports=(
  [chef_client_ident]=chef_client_ident
)

trim(){
    [[ "$1" =~ ^[[:space:]]*(.*[^[:space:]])[[:space:]]*$ ]]
    printf "%s" "${BASH_REMATCH[1]}"
}

pkg_version() {
 
  # Set the version
  version="0.0.0"

  # Determine if a version file can be found
  if [ -f $PLAN_CONTEXT/../buildnumber ]
  then
    version=`cat $PLAN_CONTEXT/../buildnumber`
    version=`trim $version`
  fi

  echo $version
}

do_before() {
  do_default_before
  update_pkg_version
}