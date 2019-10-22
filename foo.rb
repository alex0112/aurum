p1 = ["http://", "https://"]
p2 = ["api.coinbase.com", "api.coinbase.com/"]
p3 = ["v2", "/v2", "v2/", "/v2/"]
p4 = ["accounts", "/accounts", "accounts/", "/accounts/"]

s = p1.product(p2).map(&:join)
s2 = p3.product(p4).map(&:join)



f = s.product s2
f.reject! { |s|
  s = s.join()
  (s =~ /mv2/ || s =~ /2acc/ || s =~ /\/\/.[ac|m|v]/ || s =~ /.m\/\//)
}

f.each do |e|
  puts "base = \"#{e[0]}\""
  puts "path = \"#{e[1]}\"\n\n"
end

