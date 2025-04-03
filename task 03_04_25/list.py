l=[10,20]
l.append(80)

print(l)

# 1) Reverse a list in Python
print(l[::-1])

# 2) Concatenate two lists index-wise
list1 = ["A", "B", "C"]
list2 = ["X", "Y", "Z"]
concatenated_list = [list1[i] + list2[i] for i in range(len(list1))]
print(concatenated_list)

# 3) Turn every item of a list into its square
def square_list(lst):
  return list(map(lambda x: x ** 2, lst))
print(square_list(l))
    
# 4) Concatenate two lists in the following order
p=[2,7,13]
e=l.extend(p)
print(e)

# 5) Iterate both lists simultaneously
list1 = [1, 2, 3]
list2 = ['a', 'b', 'c']
for i in range(len(list1)):
  print(list1[i], list2[i])

# 6) Remove empty strings from the list of strings
words = ["Hello", "", "Python", "", "World"]
filtered_words = [word for word in words if word != ""]
print(filtered_words)

# 7) Exercise 7: Add new item to list after a specified item
l.insert(3,75)
print(l)
# 8) Extend nested list by adding the sublist
nested_list = [1, 2, [3, 4], 5]
sublist = [6, 7, 8]
nested_list[2].extend(sublist)
print(nested_list)
# 9) Replace list’s item with new value if found
my_list = [10, 20, 30, 40, 50]
old_value = 30
new_value = 300

if old_value in my_list:
  index = my_list.index(old_value)
  my_list[index] = new_value
print(my_list)

# 10) Remove all occurrences of a specific item from a list.
my_list = [1, 2, 3, 2, 4, 2, 5]
item_to_remove = 2
my_list = [x for x in my_list if x != item_to_remove]
print(my_list)
