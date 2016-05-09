web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
redis: redis-server /usr/local/etc/redis.conf
sidekiq: sidekiq -C config/sidekiq.yml -v
