if [ -z ${CHEF_POLICYFILE+x} ]
then
  policy_name="base"
else
  policy_name=${CHEF_POLICYFILE}
fi

scaffold_policy_name="$policy_name"
pkg_name=chef-${policy_name}
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