if [ ! -f "policyfile_name" ]
then
  policy_name="server_setup"
else
  policy_name=`cat policyfile_name`
fi

scaffold_policy_name="$policy_name"
pkg_name=camsa_${policy_name}
pkg_origin=camsa
pkg_version="0.1.0"
pkg_maintainer="Russell Seymour <rseymour@chef.io>"
pkg_description="CAMSA $scaffold_policy_name Policy"
pkg_upstream_url="http://chef.io"
pkg_scaffolding="core/scaffolding-chef"
pkg_svc_user=("root")
pkg_exports=(
  [chef_client_ident]=chef_client_ident
)
