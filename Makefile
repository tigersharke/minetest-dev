PORTNAME=	minetest
DISTVERSION=	g20230805
CATEGORIES=	games
PKGNAMESUFFIX=	-dev
DISTNAME=	${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

MAINTAINER=	nope@nothere
COMMENT=	Near-infinite-world block sandbox game
WWW=		https://www.minetest.net/

LICENSE=	LGPL21+

LIB_DEPENDS=	libIrrlichtMt.so:x11-toolkits/irrlicht-minetest libzstd.so:archivers/zstd

USES=		cmake compiler:c++14-lang iconv:wchar_t sqlite luajit
# Upstream requires Clang 3.5+ which for our criteria matches c++14-lang
# since https://en.cppreference.com/w/cpp/compiler_support
# lists "C++14 library support status (complete as of 3.5)"
# All other dependency version numbers are more direct and obvious, and surpass requirement.

CONFLICTS=	minetest

USE_GITHUB=     nodefault
GH_ACCOUNT=     minetest
GH_PROJECT=     minetest
GH_TAGNAME=	d16d1a13416227b671933c95937bd51165580aad

CMAKE_ARGS=	-DCMAKE_BUILD_TYPE="MinSizeRel" \
		-DCUSTOM_EXAMPLE_CONF_DIR="${PREFIX}/etc" \
		-DCUSTOM_MANDIR="${PREFIX}/man"

WRKSRC=		${WRKDIR}/${PORTNAME}-${GH_TAGNAME}

OPTIONS_DEFINE=			CURL DOCS FREETYPE LUAJIT NCURSES NLS SOUND SPATIAL SYSTEM_GMP \
				SYSTEM_JSONCPP TOUCH PROMETHEUS # SYSTEM_FONTS INSTALL_DEVTEST
OPTIONS_DEFAULT=		CURL DOCS FREETYPE LUAJIT SOUND SPATIAL SYSTEM_GMP SYSTEM_JSONCPP CLIENT GLVND
OPTIONS_MULTI=			COMP
OPTIONS_GROUP=			BUILD DATABASE
OPTIONS_SINGLE=			GRAPHICS

COMP_DESC=			Software components
OPTIONS_MULTI_COMP=		CLIENT SERVER

SYSTEM_GMP_DESC=		Use gmp from ports (ENABLE_SYSTEM_GMP)
SYSTEM_GMP_CMAKE_BOOL=		ENABLE_SYSTEM_GMP
SYSTEM_GMP_CMAKE_ON=		-DGMP_INCLUDE_DIR="${PREFIX}/include"
SYSTEM_GMP_LIB_DEPENDS=		libgmp.so:math/gmp

SYSTEM_JSONCPP_DESC=		Use jsoncpp from ports (ENABLE_SYSTEM_JSONCPP)
SYSTEM_JSONCPP_CMAKE_BOOL=	ENABLE_SYSTEM_JSONCPP
SYSTEM_JSONCPP_CMAKE_ON=	-DJSON_INCLUDE_DIR="${PREFIX}/include/jsoncpp"
SYSTEM_JSONCPP_LIB_DEPENDS=	libjsoncpp.so:devel/jsoncpp

BUILD_DESC=			Dev Build options
OPTIONS_GROUP_BUILD=		BENCHMARKS EXAMPLES UNITTESTS DEVTEST

BENCHMARKS_DESC=		Build benchmark sources (BUILD_BENCHMARKS)
BENCHMARKS_CMAKE_BOOL=		BUILD_BENCHMARKS
EXAMPLES_DESC=			BUILD_EXAMPLES
EXAMPLES_CMAKE_BOOL=		BUILD_EXAMPLES
DEVTEST_DESC=			Install Development Test game also (INSTALL_DEVTEST)
DEVTEST_CMAKE_BOOL=		INSTALL_DEVTEST
UNITTESTS_DESC=			Build unittest sources (BUILD_UNITTESTS)
UNITTESTS_CMAKE_BOOL=		BUILD_UNITTESTS

# Need to figure out how to handle this but doing so will reduce overall install.
#
#SYSTEM_FONTS_DESC=		Use same local system truetype fonts instead of bundled
#SYSTEM_FONTS_RUN_DEPENDS=	croscorefonts-fonts-ttf:x11-fonts/croscorefonts-fonts-ttf \
#				droid-fonts-ttf:x11-fonts/droid-fonts-ttf

OPTIONS_SINGLE_GRAPHICS=	GLVND LEGACY
GRAPHICS_DESC=                  Graphics support

GLVND_DESC=                     Use libOpenGL or libGLX
GLVND_CMAKE_BOOL=               ENABLE_GLVND
GLVND_CMAKE_ON=                 -DOPENGL_GL_PREFERENCE="GLVND" -DOPENGL_xmesa_INCLUDE_DIR="${PREFIX}/lib"
GLVND_USE=                      GL+=opengl

LEGACY_DESC=                    Use libGL - where GLVND may be broken on nvidia
LEGACY_CMAKE_BOOL=              ENABLE_LEGACY
LEGACY_CMAKE_ON=                -DOPENGL_GL_PREFERENCE="LEGACY" -DOPENGL_xmesa_INCLUDE_DIR="${PREFIX}/lib"
LEGACY_USE=                     GL+=opengl

DATABASE_DESC=			Database support
OPTIONS_GROUP_DATABASE=		LEVELDB PGSQL REDIS

OPTIONS_SUB=			yes

CLIENT_DESC=			Build client
CLIENT_CMAKE_BOOL=		BUILD_CLIENT
CLIENT_LIB_DEPENDS=		libIrrlichtMt.so:x11-toolkits/irrlicht-minetest \
				libpng.so:graphics/png
CLIENT_USES=			gl xorg
CLIENT_USE=			jpeg GL=gl,glu \
				XORG=ice,sm,x11,xext,xcb,xres,xshmfence,xau,xaw,xcomposite,xcursor,xdamage,xdmcp,\
				xfixes,xft,xi,xinerama,xkbfile,xmu,xpm,xrandr,xrender,xscreensaver,xt,xtst,xv,xxf86vm
SERVER_DESC=			Build server
SERVER_CMAKE_BOOL=		BUILD_SERVER

CURL_DESC=			Enable cURL support for fetching media
CURL_CMAKE_BOOL=		ENABLE_CURL
CURL_LIB_DEPENDS=		libcurl.so:ftp/curl

SOUND_DESC=			Enable sound via openal-soft
SOUND_CMAKE_BOOL=		ENABLE_SOUND

FREETYPE_DESC=			Support for TrueType fonts with unicode
FREETYPE_CMAKE_BOOL=		ENABLE_FREETYPE
FREETYPE_LIB_DEPENDS=		libfreetype.so:print/freetype2

NCURSES_DESC=			Enables server side terminal (cli option: --terminal)
NCURSES_CMAKE_BOOL=		ENABLE_CURSES
NCURSES_USES=			ncurses

# This option is becoming uncertain, though it does something, is it useful?
LUAJIT_DESC=			Enable and require LUAJIT
LUAJIT_CMAKE_BOOL_ON=		REQUIRE_LUAJIT
LUAJIT_CMAKE_BOOL_OFF=		ENABLE_LUAJIT

LEVELDB_DESC=			Enable LevelDB backend
LEVELDB_CMAKE_BOOL=		ENABLE_LEVELDB
LEVELDB_LIB_DEPENDS=		libleveldb.so:databases/leveldb

PGSQL_DESC=			Enable PostgreSQL map backend
PGSQL_USES=			pgsql
PGSQL_CMAKE_BOOL=		ENABLE_POSTGRESQL

REDIS_DESC=			Enable Redis backend
REDIS_CMAKE_BOOL=		ENABLE_REDIS
REDIS_LIB_DEPENDS=		libhiredis.so:databases/hiredis

SPATIAL_DESC=			Enable SpatialIndex (Speeds up AreaStores)
SPATIAL_LIB_DEPENDS=		libspatialindex.so:devel/spatialindex
SPATIAL_CMAKE_BOOL=		ENABLE_SPATIAL

NLS_DESC=			Native Language Support (ENABLE_GETTEXT)
NLS_CMAKE_BOOL=			ENABLE_GETTEXT
NLS_USES=			gettext
NLS_LDFLAGS=			-L${LOCALBASE}/lib

TOUCH_DESC=			Build with touch interface support
TOUCH_CMAKE_BOOL=		ENABLE_TOUCH
# dependency?

PROMETHEUS_DESC=		Build with Prometheus metrics exporter
PROMETHEUS_CMAKE_BOOL=		ENABLE_PROMETHEUS
# dependency?

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MCLIENT} && ${PORT_OPTIONS:MSOUND}
USES+=			openal
LIB_DEPENDS+=		libogg.so:audio/libogg \
			libvorbis.so:audio/libvorbis \
			libvorbisfile.so:audio/libvorbis
.endif

.if ${PORT_OPTIONS:MSERVER}
#USE_RC_SUBR=	${PORTNAME}
#USERS=		${PORTNAME}
#GROUPS=	${PORTNAME}
#USE_RC_SUBR=		minetest/ERX
USE_RC_SUBR=		minetest
USERS=			minetest
GROUPS=			minetest
.endif

post-install:
	@${ECHO_MSG} " "
	@${ECHO_MSG} "-->  "${PREFIX}/etc/"minetest.conf.example explains options and gives their default values. "
	@${ECHO_MSG} " "
	@${ECHO_MSG} "-->  Local network issues could cause singleplayer to fail. "
	@${ECHO_MSG} " "
	@${ECHO_MSG} "-->  Alternate graphics driver may be set in client config, must be to get used."
	@${ECHO_MSG} " "
	@${ECHO_MSG} " "

# --> Need to figure out about fonts, deny installing bundled ones, link to system ones instead.
#  	These are mentioned in the generate pkg-plist file.
#
# hacky way to not bring irrlicht and X11 depends for server only
#.if ! ${PORT_OPTIONS:MCLIENT} && ${PORT_OPTIONS:MSERVER}
#BROKEN= server only hack fails for irrlicht fork
#.endif
# From wiki:
#  Building without Irrlicht / X dependency
# You can build the Minetest server without library dependencies to Irrlicht or any graphical stuff.
# You still need the Irrlicht headers for this, so first, download the irrlicht source to somewhere.
#
# When invoking CMake, use -DBUILD_CLIENT=0 -DIRRLICHT_SOURCE_DIR=/wherever/you/unzipped/the/source.

#post-patch:
#	@${REINPLACE_CMD} -e 's|/usr/local|${LOCALBASE}|' \
#		${WRKSRC}/cmake/Modules/*.cmake
#
# ----------------------------
#  The fonts that minetest uses and installs can be satisfied by x11-fonts/croscorefonts-fonts-ttf and
#  x11-fonts/droid-fonts-ttf or x11-fonts/nerd-fonts so now the challenge is to substitute those in lieu
#  of the bundled ones which should reduce overall install size if those fonts are present already.
# ----------------------------
#
#
#--
# APPLY_LOCALE_BLACKLIST:BOOL=ON
# BUILD_BENCHMARKS:BOOL=FALSE
# BUILD_CLIENT:BOOL=TRUE
# BUILD_SERVER:BOOL=FALSE
# BUILD_UNITTESTS:BOOL=TRUE
# CMAKE_BUILD_TYPE:STRING=Release
# CMAKE_INSTALL_PREFIX:PATH=/usr/local
# CUSTOM_BINDIR:STRING=
# CUSTOM_DOCDIR:STRING=
# CUSTOM_EXAMPLE_CONF_DIR:STRING=
# CUSTOM_ICONDIR:STRING=
# CUSTOM_LOCALEDIR:STRING=
# CUSTOM_MANDIR:STRING=
# CUSTOM_SHAREDIR:STRING=
# CUSTOM_XDG_APPS_DIR:STRING=
# ENABLE_CURL:BOOL=ON
# ENABLE_CURSES:BOOL=ON
# ENABLE_GETTEXT:BOOL=ON
# ENABLE_LEVELDB:BOOL=ON
# ENABLE_LUAJIT:BOOL=ON
# ENABLE_POSTGRESQL:BOOL=ON
# ENABLE_PROMETHEUS:BOOL=OFF
# ENABLE_REDIS:BOOL=ON
# ENABLE_SOUND:BOOL=ON
# ENABLE_SPATIAL:BOOL=ON
# ENABLE_SYSTEM_GMP:BOOL=ON
# ENABLE_SYSTEM_JSONCPP:BOOL=ON
# ENABLE_TOUCH:BOOL=OFF
# ENABLE_UPDATE_CHECKER:BOOL=(;NOT;TRUE;)
# GETTEXT_MSGFMT:FILEPATH=/usr/local/bin/msgfmt
# INSTALL_DEVTEST:BOOL=FALSE
# IRRLICHTMT_BUILD_DIR:PATH=
# IrrlichtMt_DIR:PATH=/usr/local/lib/cmake/IrrlichtMt
# LEVELDB_INCLUDE_DIR:PATH=/usr/local/include/leveldb
# LEVELDB_LIBRARY:FILEPATH=/usr/local/lib/libleveldb.so
# REDIS_INCLUDE_DIR:PATH=/usr/local/include/hiredis
# REDIS_LIBRARY:FILEPATH=/usr/local/lib/libhiredis.so
# REQUIRE_LUAJIT:BOOL=OFF
# RUN_IN_PLACE:BOOL=FALSE
# SPATIAL_INCLUDE_DIR:PATH=/usr/local/include
# SPATIAL_LIBRARY:FILEPATH=/usr/local/lib/libspatialindex.so
# USE_GPROF:BOOL=FALSE
# VERSION_EXTRA:STRING=
# WARN_ALL:BOOL=TRUE
#--
#
# Strangely network issues can prevent singleplayer from functioning.
# GCC 		7.5+ 	or Clang 6.0+
# CMake 		3.5+ 	
# IrrlichtMt 	- 	Custom version of Irrlicht, see https://github.com/minetest/irrlicht
# Freetype 	2.0+ 	
# SQLite3 	3+ 	
# Zstd 		1.0+ 	
# LuaJIT 		2.0+ 	Bundled Lua 5.1 is used if not present
# GMP 		5.0.0+ 	Bundled mini-GMP is used if not present
# JsonCPP 	1.0.0+ 	Bundled JsonCPP is used if not present
# Curl 		7.56.0+ Optional
# gettext 	- 	Optional
.include <bsd.port.mk>
