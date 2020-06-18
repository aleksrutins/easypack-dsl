module dsl.parser;
import std.string;

struct EPDSLDecl {
    private string[string] opts;
    public string name;
    public string value;
    public string getProp(string key) {
        return opts[key];
    }
}
struct EPDSLInstance {
    private EPDSLDecl[] decls;
    public static EPDSLInstance parse(string data) {
        EPDSLInstance inst;
        EPDSLDecl[] decls = [];
        foreach(line; splitLines(data)) {
            if(line[0] == '#') continue;
            EPDSLDecl decl;
            string[] parts = line.split(" ");
            decl.name = parts[0];
            decl.value = parts[1];
            string[] optParts = parts[2 .. $];
            string[] optKeys;
            string[] optVals;
            for(int i = 0; i < optParts.length; i++) {
                if(i % 2 == 0) {
                    optKeys ~= [optParts[i]];
                } else {
                    optVals ~= [optParts[i]];
                }
            }
            for(int i = 0; i < optKeys.length; i++) {
                decl.opts[optKeys[i]] = optVals[i];
            }
            decls ~= [decl];
        }
        inst.decls = decls;
        return inst;
    }
    public EPDSLDecl getDecl(string name) {
        foreach (EPDSLDecl decl; decls)
        {
            if(decl.name == name) return decl;
        }
        return null;
    }
    public EPDSLDecl[] getDecls(string name) {
        EPDSLDecl[] res;
        foreach (EPDSLDecl decl; decls)
        {
            if(decl.name == name) res ~= [decl];
        }
        return res;
    }
}
