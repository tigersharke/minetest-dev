--- src/client/game.cpp.orig	2023-04-19 22:20:39 UTC
+++ src/client/game.cpp
@@ -1397,7 +1397,7 @@ bool Game::createSingleplayerServer(const std::string 
 	showOverlayMessage(N_("Creating server..."), 0, 5);
 
 	std::string bind_str = g_settings->get("bind_address");
-	Address bind_addr(0, 0, 0, 0, port);
+	Address bind_addr(127, 0, 0, 1, port);
 
 	if (g_settings->getBool("ipv6_server")) {
 		bind_addr.setAddress((IPv6AddressBytes *) NULL);
