#!/bin/bash 

# git           *
cat <<EOF >> ~/.pgpass       
host:port:database:user:password
EOF


#psql archive configuration
cat <<EOF >> ~/.psqlrc
--\set QUIET on

--\unset QUIET

\encoding unicode

\set AUTOCOMMIT OFF
\echo 'AUTOCOMMIT is' :AUTOCOMMIT

\pset border 2
\pset linestyle unicode
--\pset pager off
\pset null '[NULO]'

\set COMP_KEYWORD_CASE upper
\set HISTCONTROL ignoredups
\set HISTFILE ~/.psql_history
\set HISTFILE 1000000
\set PROMPT1 '(%n@%M:%>/%/) %#'
\set PROMPT2 '[more] %R > '
\set VERBOSITY verbose

\timing

\x auto

--select * from pg_roles;
EOF

