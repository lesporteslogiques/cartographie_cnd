# Exemple de liste de listes de deux éléments
liste_de_listes = [['a', 'b'], ['c', 'a'], ['b', 'a'], ['c', 'b'], ['a', 'c'], ['a', 'b']]

# Créer un dictionnaire pour compter les occurrences
occurences = {}
for elements in liste_de_listes:
    paire = tuple(elements)
    occurences[paire] = occurences.get(paire, 0) + 1

# Afficher les résultats
for paire, occurrence in occurences.items():
    print(paire, " : ", occurrence)
    # print(f"Paire: {paire}, Occurrences: {occurrence}")
