.PHONY: all clean

LUMEN := LUMEN_HOST=luajit lumen
RUNTIME := lib/lumen/runtime.lua lib/lumen/io.lua
LIBS :=	obj/lib.lua obj/motor.lua

all: bin/echo.lua

clean:
	@git checkout bin/echo.lua
	@rm -f obj/*

bin/echo.lua: $(LIBS) obj/echo.lua
	@echo $@
	@cat $(RUNTIME) $^ > $@.tmp
	@mv $@.tmp $@

obj/echo.lua: echo.l obj/lib.lua
	@echo "  $@"
	@$(LUMEN) `echo $^ | cut -d ' ' -f 2-` -c $< -o $@ -t lua

obj/motor.lua: motor.l obj/lib.lua
	@echo "  $@"
	@$(LUMEN) `echo $^ | cut -d ' ' -f 2-` -c $< -o $@ -t lua

obj/%.lua : %.l
	@echo "  $@"
	@$(LUMEN) -c $< -o $@ -t lua