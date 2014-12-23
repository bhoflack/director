.PHONY: test

test:
	corebuild -pkg yojson json_test.byte
	./json_test.byte
