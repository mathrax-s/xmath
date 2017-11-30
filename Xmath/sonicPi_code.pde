/*


live_loop :foo0 do
  use_real_time
  a ,b= sync "/osc/trigger/page0"
  use_transpose b;
  synth :pretty_bell, note: a, release: 0.8
end

live_loop :foo1 do
  use_real_time
  a ,b  = sync "/osc/trigger/page1"
  use_transpose b;
  synth :dsaw, note: a,  release: 0.5
end

live_loop :foo2 do
  use_real_time
  a ,b  = sync "/osc/trigger/page2"
  use_transpose b;
  synth :square, note: a,  release: 0.5

end

live_loop :foo3 do
  use_real_time
  sync "/osc/trigger/page3"
  sample :elec_triangle
end

live_loop :foo4 do
  use_real_time
  sync "/osc/trigger/page4"
  sample :bd_klub
end

*/