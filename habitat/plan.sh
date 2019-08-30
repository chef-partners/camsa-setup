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

pkg_version() {
  if [ -z ${BUILD_BUILDNUMBER+x} ]
  then
    echo $BUILD_BUILDNUMBER
  else
    echo "0.0.0"
  fi
}