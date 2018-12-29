#!/bin/bash
GPL="/*
  wespota_trusted_certs.h - Trusted certificate authorities for WESPOTA

  Copyright (C) 2018 Oliver Welter

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/"

sslpath="certs"
openssl="/usr/bin/openssl"
basename="/usr/bin/basename"
xxd="/usr/bin/xxd"
wc="/usr/bin/wc"
awk="/usr/bin/awk"

function errmsg()
{
	echo "$*"
	exit 1
}

[ "$1" != "" ] && sslpath="$1"
[ -d "$sslpath" ] || errmsg "Invalid or inaccessible path '$sslpath'"
[ -x "$openssl" ] && openssl=`which openssl`
[ -x "$openssl" ] || errmsg "OpenSSL binary not found"
[ -x "$basename" ] && basename=`which basename`
[ -x "$basename" ] || errmsg "Basename binary not found"
[ -x "$xxd" ] && xxd=`which xxd`
[ -x "$xxd" ] || errmsg "xxd binary not found"
[ -x "$wc" ] && wc=`which wc`
[ -x "$wc" ] || errmsg "wc binary not found"
[ -x "$awk" ] && awk=`which awk`
[ -x "$awk" ] || errmsg "awk binary not found"

IFS="
"
DEDUPL=""

numcerts=0

echo -e "$GPL\n"
echo -e "\n#ifndef _WESPOTA_TRUSTED_CERTS_H"
echo -e "#define _WESPOTA_TRUSTED_CERTS_H\n\n"

for cert in `find -type f -name "*.crt"`; do
	cname=`$basename -s ".crt" "$cert" | $awk '{ gsub("_", " ", $1); print $1 }'`

	chash=`$openssl x509 -in "$cert" -noout -hash 2>/dev/null | $awk '{print toupper($0)}'`
	cdupl=`echo "$DEDUPL" | grep $chash`
	
	if [ "$cdupl" = "" ]; then
		DEDUPL="$DEDUPL
		$chash"
	
		chex=`$openssl x509 -in "$cert" -outform der 2>/dev/null | $xxd -i 2>/dev/null`
		clen=`$openssl x509 -in "$cert" -outform der 2>/dev/null | $wc -c 2>/dev/null`
		
		numcerts=$(($numcerts + 1))

		if [ "$chash" != "" -a $clen -gt 0 -a "$chex" != "" ]; then
			echo "/* TRUSTED CERTIFICATE $chash"
			echo " * $cname"
			echo " * Length: $clen bytes"
			echo -e " */\n"
			echo "#ifdef WESPOTA_USE_TRUSTED_CERT_${chash}"
			echo "#define WESPOTA_TRUST_${chash}_LENGTH $clen"
			echo "#define WESPOTA_TRUST_${chash}_CERT { \\"
			for line in $chex; do
				echo -e "\t$line \\"
			done
			echo "}"
			echo -e "#endif\n"
		fi
	fi
done 

echo "#define WESPOTA_TRUST_CERTIFICATE_COUNT $numcerts"
echo -e "\n#endif // _WESPOTA_TRUSTED_CERTS_H"
