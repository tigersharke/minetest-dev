# Portname block
PORTNAME=		minetest
DISTVERSION=	g20240331
CATEGORIES=		games
PKGNAMESUFFIX=	-dev
DISTNAME=		${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

# Maintainer block
MAINTAINER=		nope@nothere
COMMENT=		Near-infinite-world block sandbox game
WWW=			https://www.minetest.net/

# License block
LICENSE=		LGPL21+

# dependencies
LIB_DEPENDS=	libzstd.so:archivers/zstd

# uses block
USES=			cmake iconv:wchar_t sqlite lua luajit ninja:make llvm:min=16 pkgconfig:build
USE_GITHUB=     nodefault
GH_ACCOUNT=     minetest
GH_PROJECT=     minetest
GH_TAGNAME=		d4b10db998ebeb689b3d27368e30952a42169d03

# uses=cmake related variables
CMAKE_ARGS=		-DCMAKE_BUILD_TYPE="MinSizeRel" \
				-DCUSTOM_EXAMPLE_CONF_DIR="${PREFIX}/etc" \
				-DCMAKE_CXX_FLAGS="-stdlib=libc++"

# conflicts
CONFLICTS=		minetest irrlichtMt irrlicht-minetest

# wrksrc block
WRKSRC=			${WRKDIR}/${PORTNAME}-${GH_TAGNAME}

# packaging list block
#PORTDOCS=		*
#PORTDATA=		*
# Ignoring the irreparable idiosyncratic portlint error:
# FATAL: Makefile: PORTDOCS appears in plist but DOCS is not listed in OPTIONS_DEFINE.

# options definitions
OPTIONS_DEFAULT=			CURL DOCS FREETYPE LTO LUAJIT SOUND SPATIAL SYSTEM_FONTS SYSTEM_GMP SYSTEM_JSONCPP CLIENT OPENGL
OPTIONS_GROUP=				DATABASE BUILD NEEDS MISC SYSTEM
OPTIONS_GROUP_BUILD=		BENCHMARKS DEVTEST DOCS EXAMPLES NCURSES PROFILING PROMETHEUS TOUCH UNITTESTS
OPTIONS_GROUP_DATABASE=		LEVELDB PGSQL REDIS
OPTIONS_GROUP_MISC=			LTO
OPTIONS_GROUP_NEEDS=		CURL FREETYPE NLS SOUND SPATIAL
OPTIONS_GROUP_SYSTEM=		SYSTEM_FONTS SYSTEM_GMP SYSTEM_JSONCPP SYSTEM_LUAJIT
OPTIONS_MULTI=				SOFTWARE
OPTIONS_MULTI_SOFTWARE=		CLIENT SERVER
OPTIONS_SINGLE=				GRAPHICS
OPTIONS_SINGLE_GRAPHICS=	GLES1 GLES2 OPENGL OPENGL3
OPTIONS_SUB=				yes

# options descriptions
BENCHMARKS_DESC=			Build benchmarks (Adds some benchmark chat commands)
BUILD_DESC=					Admin/Dev needs
CLIENT_DESC=				Build client and add graphics support, dependency
CURL_DESC=					Enable cURL support for fetching media: contentdb
DATABASE_DESC=				Database support
DEVTEST_DESC=				Install Development Test game also (INSTALL_DEVTEST)
DOCS_DESC=					Build and install documentation (via doxygen)
EXAMPLES_DESC=				BUILD_EXAMPLES
FREETYPE_DESC=				Support for TrueType fonts with unicode
GLES1_DESC=					Enable GLES1 --broken due to SDL--
GLES2_DESC=					Enable GLES2
GRAPHICS_DESC=				Graphics support
LEVELDB_DESC=				Enable LevelDB backend
LTO_DESC=					Build with IPO/LTO optimizations (smaller and more efficient than regular build)
MISC_DESC=					Other options
NCURSES_DESC=				Enables server side terminal (cli option: --terminal)
NEEDS_DESC=					Client essentials
NLS_DESC=					Native Language Support (ENABLE_GETTEXT)
OPENGL3_DESC=				Support OPENGL3 --Builds but seems incomplete--
OPENGL_DESC=				Support OPENGL (<3.x)
PGSQL_DESC=					Enable PostgreSQL map backend
PROFILING_DESC=				Use gprof for profiling
PROMETHEUS_DESC=			Build with Prometheus metrics exporter
REDIS_DESC=					Enable Redis backend
#SDL_DESC=					Use SDL
SERVER_DESC=				Build server
SOFTWARE_DESC=				Software components
SOUND_DESC=					Enable sound via openal-soft
SPATIAL_DESC=				Enable SpatialIndex (Speeds up AreaStores)
SYSTEM_DESC=				System subsitutes
SYSTEM_FONTS_DESC=			Use or install default fonts from ports
SYSTEM_GMP_DESC=			Use gmp from ports (ENABLE_SYSTEM_GMP)
SYSTEM_JSONCPP_DESC=		Use jsoncpp from ports (ENABLE_SYSTEM_JSONCPP)
SYSTEM_LUAJIT_DESC=			Use or install luajit-openresty from ports
TOUCH_DESC=					Build with touch interface support (to test on amd64)
UNITTESTS_DESC=				Build unit test sources (BUILD_UNITTESTS)

# options helpers
BENCHMARKS_CMAKE_BOOL=		BUILD_BENCHMARKS
CLIENT_LIB_DEPENDS=			libpng.so:graphics/png
CLIENT_USES=				gl xorg jpeg
CLIENT_USE=					GL=gl,glu \
							XORG=ice,sm,x11,xext,xcb,xres,xshmfence,xau,xaw,xcomposite,xcursor,xdamage,xdmcp,\
							xfixes,xft,xi,xinerama,xkbfile,xmu,xpm,xrandr,xrender,xscreensaver,xt,xtst,xv,xxf86vm
CLIENT_CMAKE_ON=			BUILD_CLIENT REQUIRE_LUAJIT ENABLE_LUAJIT
CURL_LIB_DEPENDS=			libcurl.so:ftp/curl
CURL_CMAKE_BOOL=			ENABLE_CURL
DEVTEST_CMAKE_BOOL=			INSTALL_DEVTEST
DOCS_CMAKE_BOOL=			BUILD_DOCUMENTATION
#DOCS_LIB_DEPENDS=
EXAMPLES_CMAKE_BOOL=		BUILD_EXAMPLES
FREETYPE_LIB_DEPENDS=		libfreetype.so:print/freetype2
FREETYPE_CMAKE_BOOL=		ENABLE_FREETYPE
GLES1_USE=					GL+=glesv1
GLES1_CMAKE_BOOL=			ENABLE_GLES1
GLES2_USE=GL+=				glesv2
GLES2_CMAKE_BOOL=			ENABLE_GLES2
LEVELDB_LIB_DEPENDS=		libleveldb.so:databases/leveldb
LEVELDB_CMAKE_BOOL=			ENABLE_LEVELDB
LTO_CMAKE_BOOL=				ENABLE_LTO
NCURSES_USES=				ncurses
NCURSES_CMAKE_BOOL=			ENABLE_CURSES
NLS_USES=					gettext
NLS_CMAKE_BOOL=				ENABLE_GETTEXT
NLS_LDFLAGS=				-L${LOCALBASE}/lib
OPENGL3_USE=				GL+=gl
OPENGL3_CMAKE_BOOL=			ENABLE_OPENGL3
OPENGL3_CMAKE_ON=			USE_SDL
OPENGL_USE=					GL+=gl
OPENGL_CMAKE_BOOL=			ENABLE_OPENGL
PGSQL_USES=					pgsql
PGSQL_CMAKE_BOOL=			ENABLE_POSTGRESQL
PROFILING_CMAKE_ON=			USE_GPROF
PROMETHEUS_CMAKE_BOOL=		ENABLE_PROMETHEUS
REDIS_LIB_DEPENDS=			libhiredis.so:databases/hiredis
REDIS_CMAKE_BOOL=			ENABLE_REDIS
#SDL_CMAKE_ON=				USE_SDL2
SERVER_CMAKE_BOOL=			BUILD_SERVER
SOUND_CMAKE_BOOL=			ENABLE_SOUND
SPATIAL_LIB_DEPENDS=		libspatialindex.so:devel/spatialindex
SPATIAL_CMAKE_BOOL=			ENABLE_SPATIAL
SYSTEM_FONTS_RUN_DEPENDS=	${LOCALBASE}/share/fonts/ChromeOS/Arimo-Bold.ttf:x11-fonts/croscorefonts-fonts-ttf \
							${LOCALBASE}/share/fonts/Droid/DroidSans.ttf:x11-fonts/droid-fonts-ttf
SYSTEM_GMP_LIB_DEPENDS=		libgmp.so:math/gmp
SYSTEM_GMP_CMAKE_BOOL=		ENABLE_SYSTEM_GMP
SYSTEM_GMP_CMAKE_ON=		-DGMP_INCLUDE_DIR="${PREFIX}/include"
SYSTEM_JSONCPP_LIB_DEPENDS=	libjsoncpp.so:devel/jsoncpp
SYSTEM_JSONCPP_CMAKE_BOOL=	ENABLE_SYSTEM_JSONCPP
SYSTEM_JSONCPP_CMAKE_ON=	-DJSON_INCLUDE_DIR="${PREFIX}/include/jsoncpp"
SYSTEM_LUAJIT_USES=			luajit:luajit-openresty
TOUCH_CMAKE_BOOL=			ENABLE_TOUCH
UNITTESTS_CMAKE_BOOL=		BUILD_UNITTESTS

# SDL cannot be used with GLES1 but having it installed causes a fail without enabled in Makefile?

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MCLIENT} && ${PORT_OPTIONS:MOPENGL}
USES+=			sdl
USE_SDL=		sdl2 ttf2
SDL_CMAKE_ON=	USE_SDL2=ON
.endif

.if ${PORT_OPTIONS:MCLIENT} && ${PORT_OPTIONS:MSOUND}
USES+=			openal
LIB_DEPENDS+=	libogg.so:audio/libogg libvorbisfile.so:audio/libvorbis
.endif

.if ${PORT_OPTIONS:MSERVER}
#USE_RC_SUBR=	${PORTNAME}
#USERS=		${PORTNAME}
#GROUPS=	${PORTNAME}
#USE_RC_SUBR=	minetest/ERX
USE_RC_SUBR=	minetest
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
