# 🧪 Probearbeitsaufgabe: Platform Engineer (Kubernetes & GitOps Fokus)

## Ziel der Aufgabe

Ziel dieser Aufgabe ist es, eine kleine, aber realistische Kubernetes-basierte Plattform aufzubauen, auf der eine containerisierte Anwendung betrieben werden kann.

Der Fokus liegt auf:

- Kubernetes als Plattform
- GitOps-basierte Deployments
- Zugriffskontrolle (RBAC)
- Netzwerk-Isolation
- grundlegende Sicherheits- und Betriebsaspekte

Wichtig: Uns interessiert vor allem dein Vorgehen, deine Entscheidungen und deine Priorisierung – nicht nur das Endergebnis.

---

## Zeitrahmen

- Ziel: 6–8 Stunden
- Du musst nicht alles vollständig umsetzen
- Unfertige Teile sind völlig in Ordnung, solange du sie dokumentierst

---

## Was bereits vorbereitet ist

Dieses Repository enthält:

- eine minimale Beispielanwendung
- Basis-Kubernetes-Manifeste
- erste RBAC-Beispiele
- ein minimales ArgoCD-Application-Manifest
- Helper-Skripte für kind und ArgoCD

Diese Vorbereitung soll Setup-Zeit reduzieren. Die eigentlichen Kernaufgaben bleiben bewusst offen.

---

## Aufgabenstellung

### 1. Kubernetes Umgebung bereitstellen

Stelle eine lokale Kubernetes-Umgebung bereit (empfohlen: kind, alternativ k3s).

Hinweis: Managed Services wie ECS/Fargate sind für diese Aufgabe nicht relevant.

Die Umgebung sollte:

- reproduzierbar sein
- eine Basis für Deployments bieten

---

### 2. Beispielanwendung deployen

Deploye die vorhandene Beispielanwendung in Kubernetes.

Die Anwendung enthält folgende Endpunkte:

| Endpoint       | Zweck                                   |
| -------------- | --------------------------------------- |
| `/health`      | Healthcheck                             |
| `/status`      | einfache Statusinformationen            |
| `/deployments` | Platzhalter für operative Informationen |
| `/admin`       | Platzhalter für Admin-Funktionen        |

Der Fokus liegt hier nicht auf Business-Logik, sondern auf Plattform-Themen.

---

### 3. Kubernetes Zugriffskontrolle (RBAC)

Statt Anwendungsebene liegt der Fokus hier auf Kubernetes-Zugriff.

Implementiere ein Rollen- und Rechtemanagement für den Cluster:

#### Rollen (Beispiel)

- `admin`
- `operator`
- `viewer`

#### Anforderungen

- Unterschiedliche Rechte auf Kubernetes-Ressourcen
- Nutzung von Kubernetes RBAC (Roles / ClusterRoles / RoleBindings)
- Nachvollziehbar:
  - wer darf was tun?
  - auf welchen Ressourcen?
  - in welchen Namespaces?

Es reicht, wenn du ein nachvollziehbares Konzept für unterschiedliche Cluster-User zeigst, z. B. über getrennte kubeconfigs, Zertifikate, ServiceAccounts oder dokumentierte Simulation. Uns geht es nicht um eine vollständige produktionsreife User-Verwaltung, sondern um nachvollziehbare Zugriffskontrolle.

---

### 4. Namespace-Isolation & Network Policies

Segmentiere die Plattform in mindestens zwei Namespaces, z. B.:

- `app`
- `platform`

Setze Network Policies ein, um:

- Kommunikation zwischen Services gezielt zu erlauben oder zu blockieren
- Isolation zwischen Namespaces zu erreichen

Beispiele:

- Nur bestimmte Services dürfen miteinander sprechen
- Kein Zugriff von außen auf interne Services

---

### 5. GitOps mit ArgoCD

Setze ein einfaches GitOps-Setup mit ArgoCD um:

- Deployment erfolgt über ein Git-Repository
- Kubernetes-Manifeste werden von ArgoCD synchronisiert

#### Anforderungen

- Anwendung wird über ArgoCD deployt
- Änderungen erfolgen über Git
- ArgoCD synchronisiert den gewünschten Zustand

Optional:

- Trennung zwischen App-Repo und Infra-Repo
- unterschiedliche Environments

---

### 6. Zugriff auf ArgoCD absichern

Binde ArgoCD in dein Rollenmodell ein:

- Zugriff auf die Web UI ist eingeschränkt
- unterschiedliche Rollen haben unterschiedliche Rechte (z. B. read-only vs. admin)

Es reicht, wenn du ArgoCD logisch in das Plattform-Rollenmodell einbindest und zeigst, wie Read-Only- und Admin-Zugriffe getrennt werden können. Eine vollständige SSO-Integration ist nicht erforderlich.

---

### 7. CI/CD (leichtgewichtig)

Optional, aber wünschenswert:

- Pipeline baut Container-Image
- Image wird in Registry gepusht
- GitOps triggert Deployment

Fokus bleibt auf GitOps, nicht auf komplexer CI/CD.

---

### 8. Observability

Implementiere mindestens einen der folgenden Punkte:

- Logging
- Healthchecks
- einfache Metriken

---

## Dokumentation

Bitte ergänze dein Repository um eine README, die Folgendes enthält:

- Architekturübersicht
- Setup-Anleitung
- Beschreibung des RBAC-Konzepts
- Erklärung der Namespace- und Network-Policy-Struktur
- Beschreibung des GitOps-Setups
- getroffene Annahmen
- offene Punkte
- was du als Nächstes verbessern würdest

---

## Hinweise

- Fokus auf Kubernetes- und Plattform-Themen, nicht auf Business-Logik
- Eine einfache, saubere Lösung ist besser als eine komplexe, unvollständige
- Du darfst Annahmen treffen – bitte dokumentiere sie
- Wenn du etwas nicht umsetzt: beschreibe kurz, wie du es lösen würdest

---

## Schneller Start

### Voraussetzungen

- Docker
- kind
- kubectl
- Node.js 20
- Git

### Lokales Setup

```bash
git clone <repo-url>
cd platform-engineer-assignment

chmod +x scripts/*.sh
./scripts/setup-kind.sh

cd app
npm ci
cd ..

./scripts/deploy-local-image.sh
kubectl apply -f k8s/base
```
