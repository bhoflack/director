.PHONY: test json_test project_test setenv


director.byte:
	corebuild -pkg yojson,async director.byte

director.native:
	corebuild -pkg yojson,async director.native

json_test:
	corebuild -pkg yojson json_test.byte
	./json_test.byte

project_test:
	corebuild -pkg yojson project_test.byte
	./project_test.byte

gitsource_test:
	corebuild gitsource_test.byte
	./gitsource_test.byte

test: json_test project_test gitsource_test

clean:
	rm -f *.byte

