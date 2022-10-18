function prt --description 'recursive cd up to project root'
    for x in (seq 1 20)
        if ! test -e ./.projectile
            cd ..
        end
    end
end
