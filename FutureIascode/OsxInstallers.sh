#!/bin/bash

#install psql-client
brew install libpq
echo 'export PATH="/usr/local/opt/libpq/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
