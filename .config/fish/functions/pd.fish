#!/usr/bin/env fish

function pd
    cd $(git rev-parse --show-toplevel)
end

pd
