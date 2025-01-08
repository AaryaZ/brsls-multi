function FindIndex(array as object, element as object) as integer
    for i = 0 to array.Count() - 1
        if array[i] = element then
            return i
        end if
    end for
    return -1
end function

function Slope(x1 as float, x2 as float, y1 as float, y2 as float) as float
    if x2 = x1 then
        print "undefined 90 "
        return -1
    end if
    m_ = (y2 - y1) / (x2 - x1)
    return m_
end function

function calculatenewx(x1 as float, y1 as float, m_ as float, y as float) as float
    x = x1 + (y - y1) / m_
    return x
end function