# export RAILS_ENV=production
export RAILS_SERVE_STATIC_FILES=1
export SECRET_KEY_BASE=`rails secret`
export RAILS_RELATIVE_URL_ROOT='/auths'
#
puma -d
