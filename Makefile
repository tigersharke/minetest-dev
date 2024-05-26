# Portname block
PORTNAME=		minetest
DISTVERSION=	g20240524
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
LIB_DEPENDS=	libzstd.so:archivers/zstd \
				libfreetype.so:print/freetype2

# uses block
USES=			cmake iconv:wchar_t sqlite ninja:make llvm:min=16 pkgconfig:build
USE_GITHUB=     nodefault
GH_ACCOUNT=     minetest
GH_PROJECT=     minetest
GH_TAGNAME=		728f643ea76278dcf89f9ac066062e7b895e46c8

# uses=cmake related variables
CMAKE_ARGS=		-DCMAKE_BUILD_TYPE="MinSizeRel" \
				-DCUSTOM_EXAMPLE_CONF_DIR="${PREFIX}/etc" \
				-DCMAKE_CXX_FLAGS="-stdlib=libc++"

# conflicts
CONFLICTS=		minetest irrlichtMt irrlicht-minetest

# wrksrc block
WRKSRC=			${WRKDIR}/${PORTNAME}-${GH_TAGNAME}

# packaging list block
#DOCS=		*
#PORTDATA=		*

# options definitions
OPTIONS_DEFAULT=			CURL DOCS LTO SOUND SPATIAL SYSTEM_LUAJIT SYSTEM_FONTS SYSTEM_GMP SYSTEM_JSONCPP CLIENT OPENGL
OPTIONS_GROUP=				BUILD DATABASE MISC NEEDS SYSTEM
OPTIONS_GROUP_BUILD=		BENCHMARKS DEVTEST DOCS NCURSES PROFILING PROMETHEUS UNITTESTS
OPTIONS_GROUP_DATABASE=		LEVELDB PGSQL REDIS
OPTIONS_GROUP_MISC=			LTO
OPTIONS_GROUP_NEEDS=		CURL NLS SOUND SPATIAL
OPTIONS_GROUP_SYSTEM=		SYSTEM_FONTS SYSTEM_GMP SYSTEM_JSONCPP SYSTEM_LUAJIT
OPTIONS_MULTI=				SOFTWARE
OPTIONS_MULTI_SOFTWARE=		CLIENT SERVER
OPTIONS_SINGLE=				GRAPHICS
OPTIONS_SINGLE_GRAPHICS=	GLES1 GLES2 OPENGL OPENGL3
OPTIONS_SUB=				yes

# options descriptions
BENCHMARKS_DESC=			Build benchmarks (Adds some benchmark chat commands) -BUILD FAILS-
BUILD_DESC=					Admin/Dev needs
CLIENT_DESC=				Build client, add graphics and sdl2 support, dependencies
CURL_DESC=					Enable cURL support for fetching media: contentdb
DATABASE_DESC=				Database support
DEVTEST_DESC=				Install Development Test game also (INSTALL_DEVTEST)
DOCS_DESC=					Build and install documentation (via doxygen)
GLES1_DESC=					Enable OpenGL ES driver, legacy
GLES2_DESC=					Enable OpenGL ES 2+ driver
GRAPHICS_DESC=				Graphics support
LEVELDB_DESC=				Enable LevelDB backend --broken - build fails--
LTO_DESC=					Build with IPO/LTO optimizations (smaller and more efficient than regular build)
MISC_DESC=					Other options
NCURSES_DESC=				Enables server side terminal (cli option: --terminal) (ENABLE_CURSES)
NEEDS_DESC=					Client essentials
NLS_DESC=					Native Language Support (ENABLE_GETTEXT)
OPENGL3_DESC=				Enable OpenGL 3+ driver --Broken shaders: Upstream flaw related to symlink--
OPENGL_DESC=				Enable OpenGL driver
PGSQL_DESC=					Enable PostgreSQL map backend
PROFILING_DESC=				Use gprof for profiling (USE_GPROF)
PROMETHEUS_DESC=			Build with Prometheus metrics exporter
REDIS_DESC=					Enable Redis backend
SERVER_DESC=				Build server
SOFTWARE_DESC=				Software components
SOUND_DESC=					Enable sound via openal-soft
SPATIAL_DESC=				Enable SpatialIndex (Speeds up AreaStores)
SYSTEM_DESC=				System subsitutes
SYSTEM_FONTS_DESC=			Use or install default fonts from ports
SYSTEM_GMP_DESC=			Use gmp from ports (ENABLE_SYSTEM_GMP)
SYSTEM_JSONCPP_DESC=		Use jsoncpp from ports (ENABLE_SYSTEM_JSONCPP)
SYSTEM_LUAJIT_DESC=			Use or install luajit from ports (instead of bundled lua)
UNITTESTS_DESC=				Build unit test sources (BUILD_UNITTESTS)

# options helpers
BENCHMARKS_CMAKE_BOOL=		BUILD_BENCHMARKS
CLIENT_LIB_DEPENDS=			libpng16.so:graphics/png
CLIENT_USES=				gl xorg jpeg sdl
CLIENT_USE=					GL+=glu \
							SDL=sdl2,ttf2 \
							XORG=ice,sm,x11,xext,xcb,xres,xshmfence,xau,xaw,xcomposite,xcursor,xdamage,xdmcp,\
							xfixes,xft,xi,xinerama,xkbfile,xmu,xpm,xrandr,xrender,xscreensaver,xt,xtst,xv,xxf86vm
CLIENT_CMAKE_BOOL=			BUILD_CLIENT
CURL_LIB_DEPENDS=			libcurl.so:ftp/curl
CURL_CMAKE_BOOL=			ENABLE_CURL
DEVTEST_CMAKE_BOOL=			INSTALL_DEVTEST
DOCS_CMAKE_BOOL=			BUILD_DOCUMENTATION
GLES1_USE=					GL+=glesv1
GLES1_CMAKE_BOOL=			ENABLE_GLES1
GLES2_USE=					GL+=glesv2
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
OPENGL_USE=					GL+=gl
OPENGL_CMAKE_BOOL=			ENABLE_OPENGL
PGSQL_USES=					pgsql
PGSQL_CMAKE_BOOL=			ENABLE_POSTGRESQL
PROFILING_CMAKE_BOOL=		USE_GPROF
PROMETHEUS_CMAKE_BOOL=		ENABLE_PROMETHEUS
REDIS_LIB_DEPENDS=			libhiredis.so:databases/hiredis
REDIS_CMAKE_BOOL=			ENABLE_REDIS
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
SYSTEM_LUAJIT_USES=			luajit
SYSTEM_LUAJIT_USE=			luajit
#SYSTEM_LUAJIT_CMAKE_BOOL=	ENABLE_LUAJIT # Redundant as one of the above includes this
UNITTESTS_CMAKE_BOOL=		BUILD_UNITTESTS

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MCLIENT} && ${PORT_OPTIONS:MSYSTEM_LUAJIT}
CMAKE_ARGS+=	-DENABLE_LUAJIT="ON" \
				-DREQUIRE_LUAJIT="ON"
.endif

# It used to be such that <OPTION>_USE= GL+=gl,opengl would satisfy, but `make test` does not agree.
.if ${PORT_OPTIONS:MCLIENT} && ${PORT_OPTIONS:MOPENGL}
USE_GL+=		glu opengl
.endif

.if ${PORT_OPTIONS:MCLIENT}
USE_GL+=		gl
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
# Warning: you might not need LIB_DEPENDS on libpng.so
# Warning: you might not need LIB_DEPENDS on libGL.so
# Warning: you might not need LIB_DEPENDS on libSDL2.so
# Warning: you might not need LIB_DEPENDS on libSDL2_ttf.so
# Warning: you might not need LIB_DEPENDS on libopenal.so.1
#----------------------------------------------------------------------
#----------------------------------------------------------------------
#CMake Warning:
#  Manually-specified variables were not used by the project:
#
#    CMAKE_MODULE_LINKER_FLAGS
#    CMAKE_SHARED_LINKER_FLAGS
#    CMAKE_VERBOSE_MAKEFILE
#    FETCHCONTENT_FULLY_DISCONNECTED
#    ICONV_INCLUDE_DIR
#    ICONV_LIBRARIES
#    LIBICONV_INCLUDE_DIR
#    LIBICONV_LIBRARIES
#    LIBICONV_LIBRARY
#----------------------------------------------------------------------

.include <bsd.port.mk>
