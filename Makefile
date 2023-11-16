PORTNAME=	minetest
DISTVERSION=	g20231114
CATEGORIES=	games
PKGNAMESUFFIX=	-dev
DISTNAME=	${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

MAINTAINER=	nope@nothere
COMMENT=	Near-infinite-world block sandbox game
WWW=		https://www.minetest.net/

LICENSE=	LGPL21+

LIB_DEPENDS=	libIrrlichtMt.so:x11-toolkits/irrlicht-minetest libzstd.so:archivers/zstd

# Upstream revised the requirement to clang 7.0.1+ (or gcc 7.5+) so this 'USES' is now a more recent feature set.
USES=		cmake compiler:c++20-lang iconv:wchar_t sqlite luajit

CONFLICTS=	minetest

USE_GITHUB=     nodefault
GH_ACCOUNT=     minetest
GH_PROJECT=     minetest
GH_TAGNAME=	aa912e90a769e4bb7578b83955389af0892dd361

CMAKE_ARGS=	-DCMAKE_BUILD_TYPE="MinSizeRel" \
		-DCUSTOM_EXAMPLE_CONF_DIR="${PREFIX}/etc" \
		-DCUSTOM_MANDIR="${PREFIX}/man"

WRKSRC=		${WRKDIR}/${PORTNAME}-${GH_TAGNAME}

OPTIONS_DEFAULT=		CURL DOCS FREETYPE LUAJIT SOUND SPATIAL SYSTEM_FONTS SYSTEM_GMP SYSTEM_JSONCPP CLIENT GLVND

OPTIONS_GROUP=			NEEDS
OPTIONS_SINGLE=			GRAPHICS
OPTIONS_GROUP+=			BUILD
OPTIONS_MULTI=			SOFTWARE
OPTIONS_MULTI+=			SYSTEM
OPTIONS_GROUP+=			DATABASE
OPTIONS_GROUP+=			MISC

NEEDS_DESC=			Client essentials
OPTIONS_GROUP_NEEDS=		CURL DOCS FREETYPE NLS SOUND SPATIAL

SYSTEM_DESC=			System subsitutes
OPTIONS_MULTI_SYSTEM=		SYSTEM_FONTS SYSTEM_GMP SYSTEM_JSONCPP SYSTEM_LUAJIT 

SOFTWARE_DESC=			Software components
OPTIONS_MULTI_SOFTWARE=		CLIENT SERVER

SYSTEM_GMP_DESC=		Use gmp from ports (ENABLE_SYSTEM_GMP)
SYSTEM_GMP_CMAKE_BOOL=		ENABLE_SYSTEM_GMP
SYSTEM_GMP_CMAKE_ON=		-DGMP_INCLUDE_DIR="${PREFIX}/include"
SYSTEM_GMP_LIB_DEPENDS=		libgmp.so:math/gmp

SYSTEM_JSONCPP_DESC=		Use jsoncpp from ports (ENABLE_SYSTEM_JSONCPP)
SYSTEM_JSONCPP_CMAKE_BOOL=	ENABLE_SYSTEM_JSONCPP
SYSTEM_JSONCPP_CMAKE_ON=	-DJSON_INCLUDE_DIR="${PREFIX}/include/jsoncpp"
SYSTEM_JSONCPP_LIB_DEPENDS=	libjsoncpp.so:devel/jsoncpp

SYSTEM_LUAJIT_DESC=		Use or install luajit-openresty from ports
SYSTEM_LUAJIT_USES=		luajit:luajit-openresty

SYSTEM_FONTS_DESC=		Use or install default fonts from ports
SYSTEM_FONTS_RUN_DEPENDS=	${LOCALBASE}/share/fonts/ChromeOS/Arimo-Bold.ttf:x11-fonts/croscorefonts-fonts-ttf \
				${LOCALBASE}/share/fonts/Droid/DroidSans.ttf:x11-fonts/droid-fonts-ttf

BUILD_DESC=			Admin/Dev needs
OPTIONS_GROUP_BUILD=		BENCHMARKS DEVTEST EXAMPLES NCURSES PROMETHEUS TOUCH UNITTESTS

BENCHMARKS_DESC=		Build benchmark sources (BUILD_BENCHMARKS)
BENCHMARKS_CMAKE_BOOL=		BUILD_BENCHMARKS
EXAMPLES_DESC=			BUILD_EXAMPLES
EXAMPLES_CMAKE_BOOL=		BUILD_EXAMPLES
DEVTEST_DESC=			Install Development Test game also (INSTALL_DEVTEST)
DEVTEST_CMAKE_BOOL=		INSTALL_DEVTEST
UNITTESTS_DESC=			Build unit test sources (BUILD_UNITTESTS)
UNITTESTS_CMAKE_BOOL=		BUILD_UNITTESTS

OPTIONS_SINGLE_GRAPHICS=	GLVND LEGACY
GRAPHICS_DESC=                  Graphics support

GLVND_DESC=                     Use libOpenGL or libGLX
GLVND_CMAKE_BOOL=               ENABLE_GLVND
GLVND_CMAKE_ON=                 -DOPENGL_GL_PREFERENCE="GLVND" -DOPENGL_xmesa_INCLUDE_DIR="${PREFIX}/lib"
GLVND_USE=                      GL+=opengl
GLVND_LIB_DEPENDS=		libOpenGL.so:graphics/libglvnd

LEGACY_DESC=                    Use libGL - where GLVND may be broken on nvidia
LEGACY_CMAKE_BOOL=              ENABLE_LEGACY
LEGACY_CMAKE_ON=                -DOPENGL_GL_PREFERENCE="LEGACY" -DOPENGL_xmesa_INCLUDE_DIR="${PREFIX}/lib"
LEGACY_USE=                     GL+=opengl

DATABASE_DESC=			Database support
OPTIONS_GROUP_DATABASE=		LEVELDB PGSQL REDIS

OPTIONS_SUB=			yes

CLIENT_DESC=			Build client and add graphics support, dependency
CLIENT_CMAKE_BOOL_ON=		BUILD_CLIENT REQUIRE_LUAJIT ENABLE_LUAJIT
CLIENT_LIB_DEPENDS=		libIrrlichtMt.so:x11-toolkits/irrlicht-minetest \
				libpng.so:graphics/png
CLIENT_USES=			gl xorg
CLIENT_USE=			jpeg GL=gl,glu \
				XORG=ice,sm,x11,xext,xcb,xres,xshmfence,xau,xaw,xcomposite,xcursor,xdamage,xdmcp,\
				xfixes,xft,xi,xinerama,xkbfile,xmu,xpm,xrandr,xrender,xscreensaver,xt,xtst,xv,xxf86vm

SERVER_DESC=			Build server
SERVER_CMAKE_BOOL=		BUILD_SERVER

CURL_DESC=			Enable cURL support for fetching media: contentdb
CURL_CMAKE_BOOL=		ENABLE_CURL
CURL_LIB_DEPENDS=		libcurl.so:ftp/curl

SOUND_DESC=			Enable sound via openal-soft
SOUND_CMAKE_BOOL=		ENABLE_SOUND

# WHOOPS!  DOCS option had done exactly nothing, docs likely always built previously.
DOCS_DESC=			Build and install documentation (via doxygen)
DOCS_CMAKE_BOOL=		BUILD_DOCUMENTATION
#DOCS_LIB_DEPENDS=		

FREETYPE_DESC=			Support for TrueType fonts with unicode
FREETYPE_CMAKE_BOOL=		ENABLE_FREETYPE
FREETYPE_LIB_DEPENDS=		libfreetype.so:print/freetype2

NCURSES_DESC=			Enables server side terminal (cli option: --terminal)
NCURSES_CMAKE_BOOL=		ENABLE_CURSES
NCURSES_USES=			ncurses

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

TOUCH_DESC=			Build with touch interface support (to test on amd64)
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

# Exactly why this must be done this way eludes me but this works and satisfies the install needs.
.if ${PORT_OPTIONS:MSYSTEM_FONTS}
pre-install:
	${RM} ${LOCALBASE}/share/minetest/fonts/Arimo-Bold.ttf
	${RM} ${LOCALBASE}/share/minetest/fonts/Arimo-BoldItalic.ttf
	${RM} ${LOCALBASE}/share/minetest/fonts/Arimo-Italic.ttf
	${RM} ${LOCALBASE}/share/minetest/fonts/Cousine-Bold.ttf
	${RM} ${LOCALBASE}/share/minetest/fonts/Cousine-BoldItalic.ttf
	${RM} ${LOCALBASE}/share/minetest/fonts/Cousine-Italic.ttf
	${RM} ${LOCALBASE}/share/minetest/fonts/Cousine-Regular.ttf
	${RM} ${LOCALBASE}/share/minetest/fonts/DroidSansFallbackFull.ttf
	${MKDIR} ${LOCALBASE}/share/minetest/fonts
	${LN} -s ${LOCALBASE}/share/fonts/ChromeOS/Arimo-Bold.ttf ${LOCALBASE}/share/minetest/fonts/Arimo-Bold.ttf
	${LN} -s ${LOCALBASE}/share/fonts/ChromeOS/Arimo-BoldItalic.ttf ${LOCALBASE}/share/minetest/fonts/Arimo-BoldItalic.ttf
	${LN} -s ${LOCALBASE}/share/fonts/ChromeOS/Arimo-Italic.ttf ${LOCALBASE}/share/minetest/fonts/Arimo-Italic.ttf
	${LN} -s ${LOCALBASE}/share/fonts/ChromeOS/Cousine-Bold.ttf ${LOCALBASE}/share/minetest/fonts/Cousine-Bold.ttf
	${LN} -s ${LOCALBASE}/share/fonts/ChromeOS/Cousine-BoldItalic.ttf ${LOCALBASE}/share/minetest/fonts/Cousine-BoldItalic.ttf
	${LN} -s ${LOCALBASE}/share/fonts/ChromeOS/Cousine-Italic.ttf ${LOCALBASE}/share/minetest/fonts/Cousine-Italic.ttf
	${LN} -s ${LOCALBASE}/share/fonts/ChromeOS/Cousine-Regular.ttf ${LOCALBASE}/share/minetest/fonts/Cousine-Regular.ttf
	${LN} -s ${LOCALBASE}/share/fonts/Droid/DroidSansFallbackFull.ttf ${LOCALBASE}/share/minetest/fonts/DroidSansFallbackFull.ttf
.endif

post-install:
	@${ECHO_MSG} " "
	@${ECHO_MSG} "-->  "${PREFIX}/etc/"minetest.conf.example explains options and gives their default values. "
	@${ECHO_MSG} " "
	@${ECHO_MSG} "-->  Local network issues could cause singleplayer to fail. "
	@${ECHO_MSG} " "
	@${ECHO_MSG} "-->  Alternate graphics driver may be set in client config, must be set to get used."
	@${ECHO_MSG} " "
	@${ECHO_MSG} " "

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

#----------------------------------------------------------------------
#
# Strangely network issues can prevent singleplayer from functioning.
# GCC 		7.5+ 	or Clang 6.0+
# CMake 	3.5+
# IrrlichtMt 	- 	Custom version of Irrlicht, see https://github.com/minetest/irrlicht
# Freetype 	2.0+
# SQLite3 	3+
# Zstd 		1.0+
# LuaJIT 	2.0+ 	Bundled Lua 5.1 is used if not present
# GMP 		5.0.0+ 	Bundled mini-GMP is used if not present
# JsonCPP 	1.0.0+ 	Bundled JsonCPP is used if not present
# Curl 		7.56.0+ Optional
# gettext 	- 	Optional
#----------------------------------------------------------------------
.include <bsd.port.mk>
