PORTNAME=	minetest
DISTVERSION=	g20220920
CATEGORIES=	games
PKGNAMESUFFIX=	-dev
DISTNAME=	${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

MAINTAINER=	nope@nothere
COMMENT=	Near-infinite-world block sandbox game

LICENSE=	LGPL21+

LIB_DEPENDS=	libIrrlichtMt.so:x11-toolkits/irrlicht-minetest libzstd.so:archivers/zstd

USES=		cmake compiler:c++14-lang iconv:wchar_t sqlite
# Upstream requires Clang 3.5+ which for our criteria matches c++14-lang
# since https://en.cppreference.com/w/cpp/compiler_support
# lists "C++14 library support status (complete as of 3.5)"
# All other dependency version numbers are more direct and obvious, and surpass requirement.

CONFLICTS=	minetest

USE_GITHUB=     nodefault
GH_ACCOUNT=     minetest
GH_PROJECT=     minetest
GH_TAGNAME=	1317cd12d74dba4ff765d6e18b0b30cdf42002a3

CMAKE_ARGS=	-DBUILD_UNITTESTS="TRUE" \
		-DCMAKE_VERBOSE_MAKEFILE="TRUE" \
		-DCMAKE_BUILD_TYPE="MinSizeRel" \
		-DCUSTOM_EXAMPLE_CONF_DIR="${PREFIX}/etc" \
		-DCUSTOM_MANDIR="${PREFIX}/man" \
		-DOPENGL_xmesa_INCLUDE_DIR="${PREFIX}/unspecified" \
		-DEGL_INCLUDE_DIR="${PREFIX}/unspecified"

WRKSRC=		${WRKDIR}/${PORTNAME}-${GH_TAGNAME}

OPTIONS_DEFINE=			CURL DOCS EXAMPLES FREETYPE LUAJIT NCURSES NLS SOUND SYSTEM_GMP \
				SYSTEM_JSONCPP TOUCH PROMETHEUS # SYSTEM_FONTS
OPTIONS_DEFAULT=		CURL FREETYPE LUAJIT SOUND SYSTEM_GMP SYSTEM_JSONCPP CLIENT GLVND SPATIAL
OPTIONS_MULTI=			COMP
OPTIONS_RADIO=			GRAPHICS
OPTIONS_GROUP=			DATABASE

COMP_DESC=			Software components
OPTIONS_MULTI_COMP=		CLIENT SERVER

OPTIONS_RADIO_GRAPHICS=		GLVND LEGACY

SYSTEM_GMP_DESC=		Use gmp from ports (ENABLE_SYSTEM_GMP)
SYSTEM_GMP_CMAKE_BOOL=		ENABLE_SYSTEM_GMP
SYSTEM_GMP_CMAKE_ON=		-DGMP_INCLUDE_DIR="${PREFIX}/include"
SYSTEM_GMP_LIB_DEPENDS=		libgmp.so:math/gmp

SYSTEM_JSONCPP_DESC=		Use jsoncpp from ports (ENABLE_SYSTEM_JSONCPP)
SYSTEM_JSONCPP_CMAKE_BOOL=	ENABLE_SYSTEM_JSONCPP
SYSTEM_JSONCPP_CMAKE_ON=	-DJSON_INCLUDE_DIR="${PREFIX}/include/jsoncpp"
SYSTEM_JSONCPP_LIB_DEPENDS=	libjsoncpp.so:devel/jsoncpp

# Need to figure out how to handle this but doing so will reduce overall install.
#
#SYSTEM_FONTS_DESC=		Use same local system truetype fonts instead of bundled
#SYSTEM_FONTS_RUN_DEPENDS=	croscorefonts-fonts-ttf:x11-fonts/croscorefonts-fonts-ttf \
#				droid-fonts-ttf:x11-fonts/droid-fonts-ttf

OPTIONS_RADIO_GRAPHICS=         GLVND LEGACY GLES
GRAPHICS_DESC=                  Graphics support

GLVND_DESC=                     Use libOpenGL or libGLX
GLVND_CMAKE_BOOL=               ENABLE_GLVND
GLVND_CMAKE_ON=                 -DOPENGL_GL_PREFERENCE="GLVND" -DOPENGL_xmesa_INCLUDE_DIR="${PREFIX}/lib"
GLVND_USE=                      GL+=opengl
GLVND_PREVENTS=                 GLES

LEGACY_DESC=                    Use libGL - where GLVND may be broken on nvidia
LEGACY_CMAKE_BOOL=              ENABLE_LEGACY
LEGACY_CMAKE_ON=                -DOPENGL_GL_PREFERENCE="LEGACY" -DOPENGL_xmesa_INCLUDE_DIR="${PREFIX}/lib"
LEGACY_USE=                     GL+=opengl
LEGACY_PREVENTS=                GLES

GLES_DESC=                      Enable GLES (requires support by IrrlichtMt) *TESTING*
GLES_CMAKE_BOOL=                ENABLE_GLES
GLVND_CMAKE_ON=                 -DEGL_INCLUDE_DIR="${PREFIX}/include/GLES"
GLES_USE=                       GL+=egl,glesv2
GLES_PREVENTS=                  GLVND LEGACY

DATABASE_DESC=			Database support
OPTIONS_GROUP_DATABASE=		LEVELDB PGSQL REDIS SPATIAL

OPTIONS_SUB=			yes

CLIENT_DESC=			Build client
CLIENT_CMAKE_BOOL=		BUILD_CLIENT
CLIENT_LIB_DEPENDS=		libIrrlichtMt.so:x11-toolkits/irrlicht-minetest \
				libpng.so:graphics/png
#CLIENT_USES=			gl jpeg xorg
CLIENT_USE=			jpeg GL=gl,glu \
				XORG=ice sm x11 xcb xres xshmfence xau xaw xcomposite \
				xcursor xdamage xdmcp xext xfixes xft xi xinerama \
				xkbfile xmu xpm xrandr xrender xt xv xxf86vm
#				XORG=ice,sm,x11,xext,xxf86vm
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

NCURSES_DESC=			Enable ncurses console
NCURSES_CMAKE_BOOL=		ENABLE_CURSES
NCURSES_USES=			ncurses

LUAJIT_DESC=			LuaJIT support (lang/luajit-openresty)
LUAJIT_CMAKE_BOOL=		ENABLE_LUAJIT REQUIRE_LUAJIT
LUAJIT_LIB_DEPENDS=		libluajit-5.1.so:lang/luajit-openresty

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
USE_RC_SUBR=		minetest
USERS=			minetest
GROUPS=			minetest
.endif

post-install:
	@${ECHO_MSG} " "
	@${ECHO_MSG} "-->  "${PREFIX}"/etc/minetest.conf.example explains options and gives their default values. "
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
#  Options/config below permits singleplayer.
# --------
#  Options        :
#        CLIENT         : on
#        CURL           : on
#        DOCS           : on
#        EXAMPLES       : on
#        FREETYPE       : on
#        GLES           : off
#        GLVND          : on
#        LEGACY         : off
#        LEVELDB        : on
#        LUAJIT         : on
#        NCURSES        : on
#        NLS            : off
#        PGSQL          : on
#        PROMETHEUS     : off
#        REDIS          : on
#        SERVER         : on
#        SOUND          : on
#        SPATIAL        : on
#        SYSTEM_GMP     : on
#        SYSTEM_JSONCPP : on
#        TOUCH          : off
# Shared Libs required:
#	libzstd.so.1
#        libvorbisfile.so.3
#        libvorbis.so.0
#        libtinfo.so.6
#        libsqlite3.so.0
#        libspatialindex.so.4
#        libpq.so.5
#        libopenal.so.1
#        libogg.so.0
#        libncurses.so.6
#        libluajit-5.1.so.2
#        libleveldb.so.1
#        libjsoncpp.so.25
#        libiconv.so.2
#        libhiredis.so.1.0.0
#        libgmp.so.10
#        libfreetype.so.6
#        libform.so.6
#        libcurl.so.4
#        libXext.so.6
#        libX11.so.6
#        libSM.so.6
#        libIrrlichtMt.so.1.9.0.8
#        libICE.so.6
.include <bsd.port.mk>
