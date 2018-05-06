test:
	ocamlbuild -use-ocamlfind test.byte && ./test.byte

play:
	ocamlbuild -use-ocamlfind main.byte && ./main.byte

check:
	bash checkenv.sh && bash checktypes.sh

zip:
	zip final_project.zip *.ml* *.json

zipcheck:
	bash checkzip.sh

clean:
	ocamlbuild -clean
	rm -f final_project.zip
