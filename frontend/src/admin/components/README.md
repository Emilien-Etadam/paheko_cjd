# Composants UI

Ajouter ici les feuilles de style des composants réutilisables (boutons, navigation, formulaires, alertes, cartes).

Exemple :

```css
/* buttons.css */
@layer components {
	.btn-primary { … }
}
```

Puis dans `admin.css` :

```css
@import "./components/buttons.css";
```

Préférer les utilitaires Tailwind dans les templates lorsque c’est suffisant.
