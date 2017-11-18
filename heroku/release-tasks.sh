#!/usr/bin/env bash
if [ "$ARTCCMGR_ENV" = "staging" ]
then
	echo "DROP SCHEMA public CASCADE;CREATE SCHEMA public;GRANT ALL ON SCHEMA public TO public;" | psql $DATABASE_URL
	bundle exec rake db:schema:load
	bundle exec rake db:seed
fi
exit
