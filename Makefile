PORTNAME=	minetest
DISTVERSION=	g20210505
CATEGORIES=	games
MASTER_SITES=	https://github.com/minetest/minetest/archive/refs/heads/
PKGNAMESUFFIX=	-dev
DISTNAME=	master
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

MAINTAINER=	nope@nothere
COMMENT=	Near-infinite-world block sandbox game

LICENSE=	LGPL21+

LIB_DEPENDS=	libsqlite3.so:databases/sqlite3 \
		libIrrlichtMt.so:x11-toolkits/irrlicht-minetest

USES=		zip cmake compiler:c11 iconv:wchar_t

CONFLICTS=	minetest

USE_GITHUB=     nodefault
GH_ACCOUNT=     minetest
GH_PROJECT=     minetest
GH_TAGNAME=	ba40b3950057c54609f8e4a56139563d30f8b84f

CMAKE_ARGS=	-DBUILD_UNITTESTS="FALSE" \
		-DCMAKE_BUILD_TYPE="MinSizeRel" \
		-DCUSTOM_EXAMPLE_CONF_DIR="${PREFIX}/etc" \
		-DCUSTOM_MANDIR="${PREFIX}/man"
WRKSRC=	${WRKDIR}/minetest-master

LDFLAGS_i386=	-Wl,-znotext

#PORTDATA=	*
#PORTDOCS=	*

OPTIONS_DEFINE=	CURL DOCS EXAMPLES FREETYPE LUAJIT NCURSES NLS SOUND SYSTEM_GMP \
		SYSTEM_JSONCPP
OPTIONS_MULTI=	COMP
OPTIONS_RADIO=	GRAPHICS
OPTIONS_GROUP=	DATABASE

COMP_DESC=		Software components
OPTIONS_MULTI_COMP=	CLIENT SERVER

OPTIONS_RADIO_GRAPHICS=	GLVND LEGACY

SYSTEM_GMP_DESC=	Use gmp from ports (ENABLE_SYSTEM_GMP)
SYSTEM_GMP_CMAKE_BOOL=	ENABLE_SYSTEM_GMP
SYSTEM_GMP_CMAKE_ON=	-DGMP_INCLUDE_DIR="${PREFIX}/include"
SYSTEM_GMP_LIB_DEPENDS=	libgmp.so:math/gmp

SYSTEM_JSONCPP_DESC=		Use jsoncpp from ports (ENABLE_SYSTEM_JSONCPP)
SYSTEM_JSONCPP_CMAKE_BOOL=	ENABLE_SYSTEM_JSONCPP
SYSTEM_JSONCPP_CMAKE_ON=	-DJSON_INCLUDE_DIR="${PREFIX}/include/jsoncpp"
SYSTEM_JSONCPP_LIB_DEPENDS=	libjsoncpp.so:devel/jsoncpp

GRAPHICS_DESC=	Graphics support
GLVND_DESC=	Use libOpenGL or libGLX
LEGACY_DESC=	Use libGL - where GLVND may be broken on nvidia

GLVND_CMAKE_ON=		-DOPENGL_GL_PREFERENCE="GLVND"
LEGACY_CMAKE_ON=	-DOPENGL_GL_PREFERENCE="LEGACY"

DATABASE_DESC=		Database support
OPTIONS_GROUP_DATABASE=	LEVELDB PGSQL REDIS SPATIAL

OPTIONS_DEFAULT=	CLIENT CURL FREETYPE GLVND LUAJIT NCURSES SERVER SOUND \
			SYSTEM_GMP SYSTEM_JSONCPP
OPTIONS_SUB=		yes

CLIENT_DESC=		Build client
CLIENT_CMAKE_BOOL=	BUILD_CLIENT
CLIENT_LIB_DEPENDS=	libIrrlichtMt.so:x11-toolkits/irrlicht-minetest \
			libpng.so:graphics/png
CLIENT_USES=		gl jpeg xorg
CLIENT_USE=		GL=gl \
			XORG=x11,xext,xxf86vm
SERVER_DESC=		Build server
SERVER_CMAKE_BOOL=	BUILD_SERVER

CURL_DESC=		Enable cURL support for fetching media
CURL_CMAKE_BOOL=	ENABLE_CURL
CURL_LIB_DEPENDS=	libcurl.so:ftp/curl
SOUND_DESC=		Enable sound
SOUND_CMAKE_BOOL=	ENABLE_SOUND
FREETYPE_DESC=		Support for TrueType fonts with unicode
FREETYPE_CMAKE_BOOL=	ENABLE_FREETYPE
FREETYPE_LIB_DEPENDS=	libfreetype.so:print/freetype2
NCURSES_DESC=		Enable ncurses console
NCURSES_CMAKE_BOOL=	ENABLE_CURSES
NCURSES_USES=		ncurses

LUAJIT_DESC=		LuaJIT support (lang/luajit-openresty)
LUAJIT_CMAKE_BOOL=	ENABLE_LUAJIT REQUIRE_LUAJIT
LUAJIT_LIB_DEPENDS=	libluajit-5.1.so:lang/luajit-openresty

PGSQL_USES=		pgsql
PGSQL_CMAKE_BOOL=	ENABLE_POSTGRESQL
LEVELDB_DESC=		Enable LevelDB backend
LEVELDB_CMAKE_BOOL=	ENABLE_LEVELDB
LEVELDB_LIB_DEPENDS=	libleveldb.so:databases/leveldb
REDIS_DESC=		Enable Redis backend
REDIS_CMAKE_BOOL=	ENABLE_REDIS
REDIS_LIB_DEPENDS=	libhiredis.so:databases/hiredis
SPATIAL_DESC=		Enable SpatialIndex AreaStore backend
SPATIAL_LIB_DEPENDS=	libspatialindex.so:devel/spatialindex
SPATIAL_CMAKE_BOOL=	ENABLE_SPATIAL

NLS_CMAKE_BOOL=	ENABLE_GETTEXT
NLS_USES=	gettext
NLS_LDFLAGS=	-L${LOCALBASE}/lib

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MCLIENT} && ${PORT_OPTIONS:MSOUND}
USES+=		openal
LIB_DEPENDS+=	libogg.so:audio/libogg \
		libvorbis.so:audio/libvorbis
.endif

.if ${PORT_OPTIONS:MSERVER}
#USE_RC_SUBR=	${PORTNAME}
#USERS=		${PORTNAME}
#GROUPS=	${PORTNAME}
USE_RC_SUBR=	minetest
USERS=		minetest
GROUPS=		minetest
.endif

# hacky way to not bring irrlicht and X11 depends for server only
.if ! ${PORT_OPTIONS:MCLIENT} && ${PORT_OPTIONS:MSERVER}
BUILD_DEPENDS+=		${NONEXISTENT}:x11-toolkits/irrlicht:patch
IRRLICHT_INCLUDE_DIR=	`${MAKE} -C ${PORTSDIR}/x11-toolkits/irrlicht -V WRKSRC`/include
CMAKE_ARGS+=		-DIRRLICHT_INCLUDE_DIR:STRING="${IRRLICHT_INCLUDE_DIR}"
EXTRA_PATCHES+=		${FILESDIR}/extra-patch-irrlichtdepend
.endif
# From wiki:
#  Building without Irrlicht / X dependency
# You can build the Minetest server without library dependencies to Irrlicht or any graphical stuff.
# You still need the Irrlicht headers for this, so first, download the irrlicht source to somewhere.
#
# When invoking CMake, use -DBUILD_CLIENT=0 -DIRRLICHT_SOURCE_DIR=/wherever/you/unzipped/the/source.

#post-patch:
#	@${REINPLACE_CMD} -e 's|/usr/local|${LOCALBASE}|' \
#		${WRKSRC}/cmake/Modules/*.cmake

.include <bsd.port.mk>
