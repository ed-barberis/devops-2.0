#!/bin/sh -eux
# debug script to display inherited environment variables.

# display environment variables explicitly set by packer. ----------------------
echo ""
echo ""
echo "--------------------------------------------------------------------------------"
echo "Packer Inherited Environment Variables"
echo "--------------------------------------------------------------------------------"
echo "HOME_DIR: ${HOME_DIR}"
echo "http_proxy: ${http_proxy}"
echo "https_proxy: ${https_proxy}"
echo "no_proxy: ${no_proxy}"
echo "--------------------------------------------------------------------------------"
echo ""
echo ""

# display all environment variables. -------------------------------------------
echo "--------------------------------------------------------------------------------"
echo "All Environment Variables"
echo "--------------------------------------------------------------------------------"
env
echo "--------------------------------------------------------------------------------"
echo ""
echo ""

