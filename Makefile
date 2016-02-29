##
## Makefile for 203hotline in /home/plasko_a/projet/ocaml/ocaml_203hotline
## 
## Made by Antoine Plaskowski
## Login   <plasko_a@epitech.eu>
## 
## Started on  Wed Mar 18 07:01:20 2015 Antoine Plaskowski
## Last update Wed Mar 25 20:26:42 2015 Antoine Plaskowski
##

203HOTLINE		=	203hotline

OCAMLC			?=	ocamlc

OCAMLFIND		?=	ocamlfind

OCAMLOPT		?=	ocamlopt

OCAMLDEP		?=	ocamldep

DEPEND			=	depend

RM			=	rm -f

DEBUG			?=	no

LEVEL			?=	3

COLOR			?=	no

LIB			=	-package archimedes,num,graphics

OCAMLFLAGS		=	$(LIB)

ifneq ($(DEBUG), no)
OCAMLFLAGS		+=	-g
endif

ifneq ($(COLOR), no)
OCAMLFLAGS		+=	-fdiagnostics-color
endif

LDFLAGS			+=	$(LIB)

DFLAGS			=	$(LIB)

SRC			=

include				source.mk

TMP			=	$(SRC:.ml=.mli)
TMP			+=	$(SRC:.ml=.cmi)
TMP			+=	$(SRC:.ml=.cmo)
TMP			+=	$(SRC:.ml=.o)

OBJ			=	$(SRC:.ml=.cmx)
OBJ_OCAML		=	$(SRC:.ml=.cmo)

all			:	$(203HOTLINE)

$(203HOTLINE)		:	$(OBJ)
				$(OCAMLFIND) $(OCAMLOPT) -linkpkg $(LDFLAGS) $(OBJ) -o $(203HOTLINE)

obj			:	$(OBJ_OCAML)

clean			:
				$(RM) $(TMP) $(OBJ)

fclean			:	clean
				$(RM) $(203HOTLINE) $(OBJ_OCAML) $(DEPEND)

re			:	fclean all

$(DEPEND)		:
				@$(OCAMLFIND) $(OCAMLDEP) $(SRC) $(DFLAGS) > $(DEPEND)

%.cmo			:	%.ml
				$(OCAMLFIND) $(OCAMLC) -c $< -o $@ $(OCAMLFLAGS)

%.cmx			:	%.ml
				$(OCAMLFIND) $(OCAMLOPT) -c $< -o $@ $(OCAMLFLAGS)

.PHONY			:	all obj clean fclean re $(DEPEND) %.cmo %.cmx

.SUFFIXES		:	.cmo.ml .o.ml

-include			$(DEPEND)
