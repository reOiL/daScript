--[[
MIT License

Copyright (c) 2017 Gabriel de Quadros Ligneul

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

function test()

    local function A(i, j)
      local ij = i+j-1
      return 1.0 / (ij * (ij-1) * 0.5 + i)
    end

    local function Av(x, y, N)
      for i=1,N do
        local a = 0
        for j=1,N do a = a + x[j] * A(i, j) end
        y[i] = a
      end
    end

    local function Atv(x, y, N)
      for i=1,N do
        local a = 0
        for j=1,N do a = a + x[j] * A(j, i) end
        y[i] = a
      end
    end

    local function AtAv(x, y, t, N)
      Av(x, t, N)
      Atv(t, y, N)
    end

    local N = 500
    local u, v, t = {}, {}, {}
    for i=1,N do u[i] = 1 end

    for i=1,10 do AtAv(u, v, t, N) AtAv(v, u, t, N) end

    local vBv, vv = 0, 0
    for i=1,N do
      local ui, vi = u[i], v[i]
      vBv = vBv + ui*vi
      vv = vv + vi*vi
    end
    return math.sqrt(vBv / vv)

end

function profile_it(profiles, fn)
  local res
  for i = 1, profiles do
    local start = os.clock()
    fn()
    local measured = os.clock() - start
    if i == 1 or res > measured then res = measured end
  end
  return res
end

print(string.format("\"spectral norm\", %.8f, 10", profile_it(10, function () test() end)))

