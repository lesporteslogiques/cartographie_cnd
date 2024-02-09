#
# Traitement des données de CND pour réalisation de la cartographie en graphe
#
# Python 3.5.3 / pip 9.0.1  //  Debian 9.5 @ kirin / 20231130 - ...
#
# Dans le fichier CSV principal, les colonnes correspondent aux index suivants
#   0  :  titre
#   1  :  mot-clé(s)
#   2  :  lab(s)
#   7  :  personne(s)
#
# Création des fichiers CSV :
#
# "index_occ_mot_cle.csv"    :  index , mot clé  , occurrences
# "index_occ_personne.csv"   :  index , personne , occurrences
# "index_occ_lab.csv"        :  index , lab      , occurrences
# "index_cnd.csv"            : index , CND
# "lien_motcle_lab.csv"      :  index mot clé , index lab      , occurrences
# "lien_motcle_motcle.csv"   :  index mot clé , index mot clé  , occurrences
# "lien_motcle_personne.csv" :  index mot clé , index personne , occurrences
# "lien_lab_personne.csv"    :  index lab     , index personne , occurrences
# "lien_cnd_personne.csv"    : index CND , index personne
# "lien_cnd_motcle.csv"      : index_CND , index_mot clé
# "lien_cnd_lab.csv"         : index_cnd , index lab



import csv
from itertools import product
from collections import Counter

fichier_csv = 'CND_19-20.csv'             # Définir le chemin du fichier CSV
fichier_mcl = 'CND_19-20_motcle_lab.csv'  # Fichier de sortie des mots clés

# listes intermédiaires

occ_motcle      = []
occ_personne    = []
occ_lab         = []
motcle_lab      = []
motcle_motcle   = []
motcle_personne = []
lab_personne    = []
occ_cnd         = []
cnd_personne    = []
cnd_motcle      = []
cnd_lab         = []

# fichiers de sortie
index_occ_motcle     = "index_occ_mot_cle.csv"
index_occ_personne   = "index_occ_personne.csv"
index_occ_lab        = "index_occ_lab.csv"
lien_motcle_lab      = "lien_motcle_lab.csv"
lien_motcle_motcle   = "lien_motcle_motcle.csv"
lien_motcle_personne = "lien_motcle_personne.csv"
lien_lab_personne    = "lien_lab_personne.csv"
index_cnd            = "index_cnd.csv"
lien_cnd_personne    = "lien_cnd_personne.csv"
lien_cnd_motcle      = "lien_cnd_motcle.csv"
lien_cnd_lab         = "lien_cnd_lab.csv"


print("\n\n   ********************************************************   \n\n")
print("1. index des CND")
print("\n\n")

champ_a_traiter = 0                     # Index du champ à traiter

with open(fichier_csv, 'r') as csvfile: # Ouvrir le fichier CSV en mode lecture
    lecteur_csv = csv.reader(csvfile)   # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)         # Lire la première ligne pour obtenir les noms des champs
    mots = []  # Créer une liste pour stocker les mots de chaque ligne du champ spécifié

    idx = 0
    for ligne in lecteur_csv:           # Parcourir les lignes du fichier CSV
        occ_cnd.append([idx, ligne[champ_a_traiter]])
        idx += 1

    for iii in occ_cnd:
        print(iii)







print("\n\n   ********************************************************   \n\n")
print("2. index et occurences des mots-clés")
print("\n\n")

champ_a_traiter = 1                     # Index du champ à traiter

with open(fichier_csv, 'r') as csvfile: # Ouvrir le fichier CSV en mode lecture
    lecteur_csv = csv.reader(csvfile)   # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)         # Lire la première ligne pour obtenir les noms des champs
    mots = []  # Créer une liste pour stocker les mots de chaque ligne du champ spécifié

    for ligne in lecteur_csv:           # Parcourir les lignes du fichier CSV
        mots.extend(ligne[champ_a_traiter].split(','))  # Séparer les mots du champ spécifié

    occurences_mots = Counter(mots)         # Utiliser Counter pour compter les occurrences de chaque mot

    # Créer un dictionnaire avec un index numérique pour chaque mot
    index_mots = {mot: index for index, (mot, _) in enumerate(occurences_mots.most_common())}

    # Imprimer le résultat (vous pouvez également le stocker dans un fichier ou effectuer d'autres opérations)
    for mot, occurence in occurences_mots.items():
        index = index_mots[mot]
        occ_motcle.append([index, mot, occurence])
    for iii in occ_motcle:
        print(iii)





print("\n\n   ********************************************************   \n\n")
print("3. index et occurences des personnes")
print("\n\n")

champ_a_traiter = 7                     # Index du champ à traiter

with open(fichier_csv, 'r') as csvfile: # Ouvrir le fichier CSV en mode lecture
    lecteur_csv = csv.reader(csvfile)   # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)         # Lire la première ligne pour obtenir les noms des champs
    mots = []  # Créer une liste pour stocker les mots de chaque ligne du champ spécifié

    for ligne in lecteur_csv:           # Parcourir les lignes du fichier CSV
        mots.extend(ligne[champ_a_traiter].split(','))  # Séparer les mots du champ spécifié

    occurences_mots = Counter(mots)         # Utiliser Counter pour compter les occurrences de chaque mot

    # Créer un dictionnaire avec un index numérique pour chaque mot
    index_mots = {mot: index for index, (mot, _) in enumerate(occurences_mots.most_common())}

    # Imprimer le résultat (vous pouvez également le stocker dans un fichier ou effectuer d'autres opérations)
    for mot, occurence in occurences_mots.items():
        index = index_mots[mot]
        occ_personne.append([index, mot, occurence])
    for iii in occ_personne:
        print(iii)




print("\n\n   ********************************************************   \n\n")
print("4. index et occurences des labs")
print("\n\n")

champ_a_traiter = 2                     # Index du champ à traiter

with open(fichier_csv, 'r') as csvfile: # Ouvrir le fichier CSV en mode lecture
    lecteur_csv = csv.reader(csvfile)   # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)         # Lire la première ligne pour obtenir les noms des champs
    mots = []  # Créer une liste pour stocker les mots de chaque ligne du champ spécifié

    for ligne in lecteur_csv:           # Parcourir les lignes du fichier CSV
        mots.extend(ligne[champ_a_traiter].split(','))  # Séparer les mots du champ spécifié

    occurences_mots = Counter(mots)         # Utiliser Counter pour compter les occurrences de chaque mot

    # Créer un dictionnaire avec un index numérique pour chaque mot
    index_mots = {mot: index for index, (mot, _) in enumerate(occurences_mots.most_common())}

    # Imprimer le résultat (vous pouvez également le stocker dans un fichier ou effectuer d'autres opérations)
    for mot, occurence in occurences_mots.items():
        index = index_mots[mot]
        occ_lab.append([index, mot, occurence])
    for iii in occ_lab:
        print(iii)





print("\n\n   ********************************************************   \n\n")
print("5. associer mots clés et labs / occurences tags-labs")
print("\n\n")

with open(fichier_csv, 'r') as csvfile:   # Ouvrir le fichier en mode lecture

    lecteur_csv = csv.reader(csvfile)     # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)           # Lire la première ligne pour obtenir les noms des champs
    indices_champs_a_garder = [1, 2]      # Indiquer les indices des champs à conserver
    lignes_modifiees = []                 # Créer une liste pour stocker les lignes modifiées

    for ligne in lecteur_csv:             # Parcourir les lignes du fichier CSV
        champs_selectionnes = [ligne[i] for i in indices_champs_a_garder]  # Sélectionner seulement les champs spécifiés par les indices
        lignes_modifiees.append(champs_selectionnes) # Ajouter la nouvelle ligne à la liste

# Imprimer les lignes modifiées (vous pouvez également les enregistrer dans un nouveau fichier)
#for ligne_modifiee in lignes_modifiees:
#   print(ligne_modifiee)

combinaisons_all = []

for ligne_mod in lignes_modifiees:
    # Générer toutes les combinaisons possibles des éléments des champs de cette ligne
    combinaisons = product(*[champ.split(',') for champ in ligne_mod])

    # itertools.product renvoie un itérateur, il faut transformer le résultat en liste
    combinaisons_liste = list(combinaisons)
    # print("combinaisons_liste")
    for combinaison in combinaisons_liste:
        combinaisons_all.append(combinaison)

# Créer un dictionnaire pour compter les occurrences
occurences_mc_labs = {}
for element1, element2 in combinaisons_all:
    paire = (element1, element2)
    # print(paire)
    occurences_mc_labs[paire] = occurences_mc_labs.get(paire, 0) + 1
for paire, occurrence in occurences_mc_labs.items():
    print(paire, " : " , occurrence)



print("\n\n   ********************************************************   \n\n")
print("6. associer CND et personnes / occurences CND - personnes")
print("\n\n")

with open(fichier_csv, 'r') as csvfile:   # Ouvrir le fichier en mode lecture

    lecteur_csv = csv.reader(csvfile)     # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)           # Lire la première ligne pour obtenir les noms des champs
    indices_champs_a_garder = [0, 7]      # Indiquer les indices des champs à conserver
    lignes_modifiees = []                 # Créer une liste pour stocker les lignes modifiées

    for ligne in lecteur_csv:             # Parcourir les lignes du fichier CSV
        champs_selectionnes = [ligne[i] for i in indices_champs_a_garder]  # Sélectionner seulement les champs spécifiés par les indices
        lignes_modifiees.append(champs_selectionnes) # Ajouter la nouvelle ligne à la liste

# Imprimer les lignes modifiées (vous pouvez également les enregistrer dans un nouveau fichier)
for ligne_modifiee in lignes_modifiees:
    print(ligne_modifiee)
print(". . . . . . . . ")

combinaisons_all = []

for ligne_modifiee in lignes_modifiees:
    cle, valeurs = ligne_modifiee
    valeurs_liste = valeurs.split(',')

    for v in valeurs_liste:
        combinaisons_all.append((cle, v))

# Créer un dictionnaire pour compter les occurrences
occurences_cnd_pers = {}
for element1, element2 in combinaisons_all:
    paire = (element1, element2)
    # print(paire)
    occurences_cnd_pers[paire] = occurences_cnd_pers.get(paire, 0) + 1
for paire, occurrence in occurences_cnd_pers.items():
    print(paire, " : " , occurrence)




print("\n\n   ********************************************************   \n\n")
print("7. associer CND et mot clé / occurences CND - mot-clé")
print("\n\n")

with open(fichier_csv, 'r') as csvfile:   # Ouvrir le fichier en mode lecture

    lecteur_csv = csv.reader(csvfile)     # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)           # Lire la première ligne pour obtenir les noms des champs
    indices_champs_a_garder = [0, 1]      # Indiquer les indices des champs à conserver
    lignes_modifiees = []                 # Créer une liste pour stocker les lignes modifiées

    for ligne in lecteur_csv:             # Parcourir les lignes du fichier CSV
        champs_selectionnes = [ligne[i] for i in indices_champs_a_garder]  # Sélectionner seulement les champs spécifiés par les indices
        lignes_modifiees.append(champs_selectionnes) # Ajouter la nouvelle ligne à la liste

# Imprimer les lignes modifiées (vous pouvez également les enregistrer dans un nouveau fichier)
for ligne_modifiee in lignes_modifiees:
    print(ligne_modifiee)
print(". . . . . . . . ")

combinaisons_all = []

for ligne_modifiee in lignes_modifiees:
    cle, valeurs = ligne_modifiee
    valeurs_liste = valeurs.split(',')

    for v in valeurs_liste:
        combinaisons_all.append((cle, v))

# Créer un dictionnaire pour compter les occurrences
occurences_cnd_mc = {}
for element1, element2 in combinaisons_all:
    paire = (element1, element2)
    # print(paire)
    occurences_cnd_mc[paire] = occurences_cnd_mc.get(paire, 0) + 1
for paire, occurrence in occurences_cnd_mc.items():
    print(paire, " : " , occurrence)









print("\n\n   ********************************************************   \n\n")
print("8. associer CND et labs / occurences CND - labs")
print("\n\n")

with open(fichier_csv, 'r') as csvfile:   # Ouvrir le fichier en mode lecture

    # le champ 0 ne doit pas être splitté sur la virgule!

    lecteur_csv = csv.reader(csvfile)     # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)           # Lire la première ligne pour obtenir les noms des champs
    indices_champs_a_garder = [0, 2]      # Indiquer les indices des champs à conserver
    lignes_modifiees = []                 # Créer une liste pour stocker les lignes modifiées

    for ligne in lecteur_csv:             # Parcourir les lignes du fichier CSV
        champs_selectionnes = [ligne[i] for i in indices_champs_a_garder]  # Sélectionner seulement les champs spécifiés par les indices
        lignes_modifiees.append(champs_selectionnes) # Ajouter la nouvelle ligne à la liste

# Imprimer les lignes modifiées (vous pouvez également les enregistrer dans un nouveau fichier)
for ligne_modifiee in lignes_modifiees:
    print(ligne_modifiee)
print(". . . . . . . . ")

combinaisons_all = []

for ligne_modifiee in lignes_modifiees:
    cle, valeurs = ligne_modifiee
    valeurs_liste = valeurs.split(',')

    for v in valeurs_liste:
        combinaisons_all.append((cle, v))

# Créer un dictionnaire pour compter les occurrences
occurences_cnd_labs = {}
for element1, element2 in combinaisons_all:
    paire = (element1, element2)
    # print(paire)
    occurences_cnd_labs[paire] = occurences_cnd_labs.get(paire, 0) + 1
for paire, occurrence in occurences_cnd_labs.items():
    print(paire, " : " , occurrence)







print("\n\n   ********************************************************   \n\n")
print("9. associer mots clés et personnes / occurences personnes-tags")
print("\n\n")

with open(fichier_csv, 'r') as csvfile:   # Ouvrir le fichier en mode lecture

    lecteur_csv = csv.reader(csvfile)     # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)           # Lire la première ligne pour obtenir les noms des champs
    indices_champs_a_garder = [1, 7]      # Indiquer les indices des champs à conserver
    lignes_modifiees = []                 # Créer une liste pour stocker les lignes modifiées

    for ligne in lecteur_csv:             # Parcourir les lignes du fichier CSV
        champs_selectionnes = [ligne[i] for i in indices_champs_a_garder]  # Sélectionner seulement les champs spécifiés par les indices
        lignes_modifiees.append(champs_selectionnes) # Ajouter la nouvelle ligne à la liste

# Imprimer les lignes modifiées (vous pouvez également les enregistrer dans un nouveau fichier)
#for ligne_modifiee in lignes_modifiees:
#   print(ligne_modifiee)

combinaisons_all = []

for ligne_mod in lignes_modifiees:
    # Générer toutes les combinaisons possibles des éléments des champs de cette ligne
    combinaisons = product(*[champ.split(',') for champ in ligne_mod])

    # itertools.product renvoie un itérateur, il faut transformer le résultat en liste
    combinaisons_liste = list(combinaisons)
    # print("combinaisons_liste")
    for combinaison in combinaisons_liste:
        combinaisons_all.append(combinaison)

# Créer un dictionnaire pour compter les occurrences
occurences_mc_pers = {}
for element1, element2 in combinaisons_all:
    paire = (element1, element2)
    # print(paire)
    occurences_mc_pers[paire] = occurences_mc_pers.get(paire, 0) + 1
for paire, occurrence in occurences_mc_pers.items():
    print()
    #print(paire, " : " , occurrence)







print("\n\n   ********************************************************   \n\n")
print("10. associer labs et personnes / occurences personnes-labs")
print("\n\n")

with open(fichier_csv, 'r') as csvfile:   # Ouvrir le fichier en mode lecture

    lecteur_csv = csv.reader(csvfile)     # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)           # Lire la première ligne pour obtenir les noms des champs
    indices_champs_a_garder = [2, 7]      # Indiquer les indices des champs à conserver
    lignes_modifiees = []                 # Créer une liste pour stocker les lignes modifiées

    for ligne in lecteur_csv:             # Parcourir les lignes du fichier CSV
        champs_selectionnes = [ligne[i] for i in indices_champs_a_garder]  # Sélectionner seulement les champs spécifiés par les indices
        lignes_modifiees.append(champs_selectionnes) # Ajouter la nouvelle ligne à la liste

# Imprimer les lignes modifiées (vous pouvez également les enregistrer dans un nouveau fichier)
#for ligne_modifiee in lignes_modifiees:
#   print(ligne_modifiee)

combinaisons_all = []

for ligne_mod in lignes_modifiees:
    # Générer toutes les combinaisons possibles des éléments des champs de cette ligne
    combinaisons = product(*[champ.split(',') for champ in ligne_mod])

    # itertools.product renvoie un itérateur, il faut transformer le résultat en liste
    combinaisons_liste = list(combinaisons)
    # print("combinaisons_liste")
    for combinaison in combinaisons_liste:
        combinaisons_all.append(combinaison)

# Créer un dictionnaire pour compter les occurrences
occurences_lab_pers = {}
for element1, element2 in combinaisons_all:
    paire = (element1, element2)
    # print(paire)
    occurences_lab_pers[paire] = occurences_lab_pers.get(paire, 0) + 1
for paire, occurrence in occurences_lab_pers.items():
    print("    ")
    # print(paire, " : " , occurrence)




print("\n\n   ********************************************************   \n\n")
print("11. associer mots clés et mots clés / occurences tags-tags")
print("\n\n")

with open(fichier_csv, 'r') as csvfile:   # Ouvrir le fichier en mode lecture

    lecteur_csv = csv.reader(csvfile)     # Créer un objet lecteur CSV
    entetes = next(lecteur_csv)           # Lire la première ligne pour obtenir les noms des champs
    indices_champs_a_garder = [1]         # Indiquer les indices des champs à conserver
    lignes_modifiees = []                 # Créer une liste pour stocker les lignes modifiées

    for ligne in lecteur_csv:             # Parcourir les lignes du fichier CSV
        champs_selectionnes = [ligne[i] for i in indices_champs_a_garder]  # Sélectionner seulement les champs spécifiés par les indices
        lignes_modifiees.append(champs_selectionnes) # Ajouter la nouvelle ligne à la liste

combinaisons_all = []

# Imprimer les lignes modifiées (vous pouvez également les enregistrer dans un nouveau fichier)
for ligne_modifiee in lignes_modifiees:
    # print(type(ligne_modifiee))
    el = "".join(ligne_modifiee)
    elements = el.split(',')
    combinaisons = list(product(elements, repeat=2))
    # Enlever les combinaisons de mots identiques
    combinaisons_filtrees = [comb for comb in combinaisons if comb[0] != comb[1]]
    # Trier les listes de listes par ordre alpha
    liste_de_listes_triee = [sorted(subliste) for subliste in combinaisons_filtrees]

    # Afficher le résultat

    for combinaison in liste_de_listes_triee:
        print(combinaison)
        combinaisons_all.append(combinaison)

print("\n\n occurences mc mc\n\n")
# Créer un dictionnaire pour compter les occurrences
occurences_mc_mc = {}
for element1, element2 in combinaisons_all:
    paire = (element1, element2)
    # print(paire)
    occurences_mc_mc[paire] = occurences_mc_mc.get(paire, 0) + 1
for paire, occurrence in occurences_mc_mc.items():
    print("")
    # print(paire, " : " , occurrence)





print("\n\n   ********************************************************   \n\n")
print("12. (export) mots clés (identifiés par leur index) avec occurrence")
print("\n\n")

# Réorganiser la liste de listes par le premier élément
occ_motcle_triee = sorted(occ_motcle, key=lambda x: x[0])

for mc in occ_motcle_triee:
    print()
    # print(mc[0], " :: ", mc[1], " :: ", mc[2])

# Écrire la liste de listes dans le fichier CSV
with open(index_occ_motcle, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # Écrire chaque sous-liste comme une ligne dans le fichier CSV
    for sous_liste in occ_motcle_triee:
        ecrivain_csv.writerow(sous_liste)





print("\n\n   ********************************************************   \n\n")
print("13. (export) CND (identifiés par leur index) avec occurrence")
print("\n\n")

# Réorganiser la liste de listes par le premier élément
occ_cnd_triee = sorted(occ_cnd, key=lambda x: x[0])

for cnd in occ_cnd_triee:
    print(cnd)
    print(cnd[0], " :: ", cnd[1])

# Écrire la liste de listes dans le fichier CSV
with open(index_cnd, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # Écrire chaque sous-liste comme une ligne dans le fichier CSV
    for sous_liste in occ_cnd_triee:
        ecrivain_csv.writerow(sous_liste)




print("\n\n   ********************************************************   \n\n")
print("14. (export) personnes (identifiées par leur index) avec occurrence")
print("\n\n")

# Réorganiser la liste de listes par le premier élément
occ_personne_triee = sorted(occ_personne, key=lambda x: x[0])

for mc in occ_personne_triee:
    print()
    # print(mc[0], " :: ", mc[1], " :: ", mc[2])

# Écrire la liste de listes dans le fichier CSV
with open(index_occ_personne, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # Écrire chaque sous-liste comme une ligne dans le fichier CSV
    for sous_liste in occ_personne_triee:
        ecrivain_csv.writerow(sous_liste)




print("\n\n   ********************************************************   \n\n")
print("15. (export) personnes (identifiées par leur index) avec occurrence")
print("\n\n")

# Réorganiser la liste de listes par le premier élément
occ_lab_triee = sorted(occ_lab, key=lambda x: x[0])

for mc in occ_lab_triee:
    print()
    # print(mc[0], " :: ", mc[1], " :: ", mc[2])

# Écrire la liste de listes dans le fichier CSV
with open(index_occ_lab, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # Écrire chaque sous-liste comme une ligne dans le fichier CSV
    for sous_liste in occ_lab_triee:
        ecrivain_csv.writerow(sous_liste)




print("\n\n   ********************************************************   \n\n")
print("16. (export) liens mot-clé-tag (identifiées par leur index) avec occurrences")
print("\n\n")

with open(lien_motcle_lab, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # paire = tag / lab
    for paire, occurrence in occurences_mc_labs.items():
        #print(paire[0], " / ", paire[1], " : " , occurrence)

        # Initialiser les valeurs à -1 pour identifier les manquants
        index_mc = -1
        index_lab = -1

        # Rechercher la valeur d'index du mot clé
        for ligne in occ_motcle:
            if ligne[1] == paire[0]:
                #print("match : ", paire[0], ligne)
                index_mc = ligne[0]

        # Rechercher la valeur d'index du lab
        for ligne in occ_lab:
            if ligne[1] == paire[1]:
                #print("match : ", paire[1], ligne)
                index_lab = ligne[0]

        row = [index_mc, index_lab, occurrence]
        ecrivain_csv.writerow(row)
        #print(row)





print("\n\n   ********************************************************   \n\n")
print("17. (export) liens tags-tags (identifiées par leur index) avec occurrences")
print("\n\n")

with open(lien_motcle_motcle, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # paire = tag / lab
    for paire, occurrence in occurences_mc_mc.items():
        #print(paire[0], " / ", paire[1], " : " , occurrence)

        # Initialiser les valeurs à -1 pour identifier les manquants
        index_mc1 = -1
        index_mc2 = -1

        # Rechercher la valeur d'index du mot clé
        for ligne in occ_motcle:
            if ligne[1] == paire[0]:
                index_mc1 = ligne[0]
            if ligne[1] == paire[1]:
                index_mc2 = ligne[0]

        row = [index_mc1, index_mc2, occurrence]
        ecrivain_csv.writerow(row)
        #print(row)





print("\n\n   ********************************************************   \n\n")
print("18. (export) liens mot clé-personne (identifiées par leur index) avec occurrences")
print("\n\n")

with open(lien_motcle_personne, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # paire = tag / lab
    for paire, occurrence in occurences_mc_pers.items():
        #print(paire[0], " / ", paire[1], " : " , occurrence)

        # Initialiser les valeurs à -1 pour identifier les manquants
        index_mc = -1
        index_pers = -1

        # Rechercher la valeur d'index du mot clé
        for ligne in occ_motcle:
            if ligne[1] == paire[0]:
                #print("match : ", paire[0], ligne)
                index_mc = ligne[0]  # TODO ça renvoie une mauvais index

        # Rechercher la valeur d'index du lab
        for ligne in occ_personne:
            if ligne[1] == paire[1]:
                #print("match : ", paire[1], ligne)
                index_pers = ligne[0]

        row = [index_mc, index_pers, occurrence]
        ecrivain_csv.writerow(row)
        #print(row)





print("\n\n   ********************************************************   \n\n")
print("19. (export) liens lab-personne (identifiées par leur index) avec occurrences")
print("\n\n")

with open(lien_lab_personne, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # paire = lab / personne
    for paire, occurrence in occurences_lab_pers.items():
        #print(paire[0], " / ", paire[1], " : " , occurrence)

        # Initialiser les valeurs à -1 pour identifier les manquants
        index_lab = -1
        index_pers = -1

        # Rechercher la valeur d'index du lab
        for ligne in occ_lab:
            if ligne[1] == paire[0]:
                #print("match : ", paire[1], ligne)
                index_lab = ligne[0]

        # Rechercher la valeur d'index du lab
        for ligne in occ_personne:
            if ligne[1] == paire[1]:
                #print("match : ", paire[1], ligne)
                index_pers = ligne[0]

        row = [index_lab, index_pers, occurrence]
        ecrivain_csv.writerow(row)
        #print(row)





print("\n\n   ********************************************************   \n\n")
print("20. (export) liens CND-personne (identifiées par leur index) avec occurrences")
print("\n\n")

with open(lien_cnd_personne, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # paire = lab / personne
    for paire, occurrence in occurences_cnd_pers.items():
        print(paire[0], " / ", paire[1], " : " , occurrence)

        # Initialiser les valeurs à -1 pour identifier les manquants
        index_cnd = -1
        index_pers = -1

        # Rechercher la valeur d'index de la CND
        for ligne in occ_cnd:
            if ligne[1] == paire[0]:
                print("match : ", paire[1], ligne)
                index_cnd = ligne[0]

        # Rechercher la valeur d'index de la personne
        for ligne in occ_personne:
            if ligne[1] == paire[1]:
                #print("match : ", paire[1], ligne)
                index_pers = ligne[0]

        row = [index_cnd, index_pers, occurrence]
        ecrivain_csv.writerow(row)
        print(row)






print("\n\n   ********************************************************   \n\n")
print("21. (export) liens CND-motcle (identifiées par leur index) avec occurrences")
print("\n\n")

with open(lien_cnd_motcle, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # paire = lab / personne
    for paire, occurrence in occurences_cnd_mc.items():
        print(paire[0], " / ", paire[1], " : " , occurrence)

        # Initialiser les valeurs à -1 pour identifier les manquants
        index_cnd = -1
        index_mc = -1

        # Rechercher la valeur d'index de la CND
        for ligne in occ_cnd:
            if ligne[1] == paire[0]:
                #print("match : ", paire[1], ligne)
                index_cnd = ligne[0]

        # Rechercher la valeur d'index de la personne
        for ligne in occ_motcle:
            if ligne[1] == paire[1]:
                #print("match : ", paire[1], ligne)
                index_mc = ligne[0]

        row = [index_cnd, index_mc, occurrence]
        ecrivain_csv.writerow(row)
        print(row)






print("\n\n   ********************************************************   \n\n")
print("22. (export) liens CND-lab (identifiées par leur index) avec occurrences")
print("\n\n")

with open(lien_cnd_lab, 'w', newline='') as csvfile:
    ecrivain_csv = csv.writer(csvfile)
    # paire = lab / personne
    for paire, occurrence in occurences_cnd_labs.items():


        # Initialiser les valeurs à -1 pour identifier les manquants
        index_cnd = -1
        index_lab = -1

        # Rechercher la valeur d'index de la CND
        for ligne in occ_cnd:
            if ligne[1] == paire[0]:
                #print("match : ", paire[1], ligne)
                index_cnd = ligne[0]

        # Rechercher la valeur d'index de la personne
        for ligne in occ_lab:
            if ligne[1] == paire[1]:
                #print("match : ", paire[1], ligne)
                index_lab = ligne[0]

        row = [index_cnd, index_lab, occurrence]
        ecrivain_csv.writerow(row)
        print(paire[0], " / ", paire[1], " : " , occurrence, " / ", row)
