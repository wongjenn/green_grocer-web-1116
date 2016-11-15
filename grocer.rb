def consolidate_cart(cart)
  result = {}
  cart.each do |items|
    items.each do |item, data|
      result[item] ||= data
      result[item][:count].nil? ? result[item][:count] = 1 : result[item][:count] += 1
    end
  end
  result
end

def apply_coupons(cart, coupons = 0)
  new_hash = {}

  coupons.each do |coupon|
    cart.each do |items, data|

      if coupon[:item] == items
        new_item = "#{items} W/COUPON"

        if new_hash[new_item].nil?
          new_hash[new_item] = {}
          new_hash[new_item][:price] = coupon[:cost]
          new_hash[new_item][:clearance] = data[:clearance]
          new_hash[new_item][:count] = 0
        end

        if data[:count] == 0 || coupon[:num] > data[:count]
          next
        else
          new_hash[new_item][:count] += 1
          data[:count] -= coupon[:num]
        end
      end
    end
  end

  cart.merge!(new_hash)
end

def apply_clearance(cart)
  cart.each do |items, data|
    if data[:clearance] == true
      data[:price] *= 0.8
      data[:price] = data[:price].round(1)
    end
  end
end

def checkout(cart, coupons)
  total = 0
  consolidated = apply_coupons(consolidate_cart(cart), coupons)
  clearance = apply_clearance(consolidated)
  clearance.each {|items, data| total += data[:price] * data[:count]}
  total > 100 ? total *= 0.90 : total
end
