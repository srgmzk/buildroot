################################################################################
#
# libcpprestsdk
#
################################################################################

LIBCPPRESTSDK_VERSION = 2.10.14
LIBCPPRESTSDK_SITE = $(call github,Microsoft,cpprestsdk,v$(LIBCPPRESTSDK_VERSION))
LIBCPPRESTSDK_LICENSE = MIT
LIBCPPRESTSDK_LICENSE_FILES = license.txt
LIBCPPRESTSDK_SUBDIR = Release
LIBCPPRESTSDK_DEPENDENCIES += host-pkgconf boost openssl zlib
LIBCPPRESTSDK_CONF_OPTS = -DWERROR=OFF -DBUILD_SAMPLES=OFF

ifeq ($(BR2_STATIC_LIBS),y)
LIBCPPRESTSDK_CONF_OPTS += \
	-DBoost_USE_STATIC_LIBS=ON \
	-DBoost_USE_STATIC_RUNTIME=ON
endif

LIBCPPRESTSDK_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
LIBCPPRESTSDK_CXXFLAGS += -latomic
endif

ifeq ($(BR2_PACKAGE_BROTLI),y)
LIBCPPRESTSDK_DEPENDENCIES += brotli
LIBCPPRESTSDK_CONF_OPTS += -DCPPREST_EXCLUDE_BROTLI=OFF
else
LIBCPPRESTSDK_CONF_OPTS += -DCPPREST_EXCLUDE_BROTLI=ON
endif

ifeq ($(BR2_PACKAGE_WEBSOCKETPP),y)
LIBCPPRESTSDK_DEPENDENCIES += websocketpp
LIBCPPRESTSDK_CONF_OPTS += -DCPPREST_EXCLUDE_WEBSOCKETS=OFF
else
LIBCPPRESTSDK_CONF_OPTS += -DCPPREST_EXCLUDE_WEBSOCKETS=ON
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
LIBCPPRESTSDK_CXXFLAGS += -O0
endif

LIBCPPRESTSDK_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(LIBCPPRESTSDK_CXXFLAGS)"

$(eval $(cmake-package))
