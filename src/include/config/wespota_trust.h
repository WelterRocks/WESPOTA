/*
  wespota_trust.h - user specific trust configuration for WESPOTA

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
*/

#ifndef _WESPOTA_TRUST_H_
#define _WESPOTA_TRUST_H_

#ifdef USE_MQTT_TLS_CA_CERT

// USE NEW CERTSTORE FOR MQTT TLS CA CERT
// WESPOTA_TRUST_4F06F81D is LetsEncrypt X3 signed by IdenTrust
#define USE_WESPOTA_TRUST_4F06F81D

#define MQTT_TLS_CA_CERT_LENGTH WESPOTA_TRUST_4F06F81D_LENGTH
#define MQTT_TLS_CA_CERT WESPOTA_TRUST_4F06F81D_CERT

#endif  // USE_MQTT_TLS_CA_CERT

#endif  // _WESPOTA_TRUST_H_
