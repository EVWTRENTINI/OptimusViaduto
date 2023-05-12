function mcrdir = diretorio_mcr()
mcrdir = mcrcachedir;

for i = length(mcrdir):-1:1
    if ispc == true
        separador = '\';
    end
    if isunix == true
        separador = '/';
    end
    if mcrdir(i) == separador
        break
    end
    mcrdir = mcrdir(1:i-1);
end

end