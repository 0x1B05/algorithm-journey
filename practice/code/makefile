JC = javac
JI = java
JFLAGS = -g -d bin

SRCDIR = src
BINDIR = bin

# Rule to compile Java files
$(BINDIR)/%.class: $(SRCDIR)/%.java
	$(JC) $(JFLAGS) $<

# Rule to run a specific Java class with input from input.txt
%: $(BINDIR)/$(PACKAGE)/%.class
	$(JI) -classpath $(BINDIR) $(PACKAGE).$@ < input.txt

clean:
	rm -r $(BINDIR)/*

.PHONY: clean
