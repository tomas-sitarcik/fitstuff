/**
 * Kostra programu pro 2. projekt IZP 2022/23
 *
 * Jednoducha shlukova analyza: 2D nejblizsi soused.
 * Single linkage
 */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <math.h> // sqrtf
#include <limits.h> // INT_MAX
#include <ctype.h> // isdigit

/*****************************************************************
 * Ladici makra. Vypnout jejich efekt lze definici makra
 * NDEBUG, napr.:
 *   a) pri prekladu argumentem prekladaci -DNDEBUG
 *   b) v souboru (na radek pred #include <assert.h>
 *      #define NDEBUG
 */

#ifdef NDEBUG
#define debug(s)
#define dfmt(s, ...)
#define dint(i)
#define dfloat(f)
#else

// vypise ladici retezec
#define debug(s) printf("- %s\n", s)

// vypise formatovany ladici vystup - pouziti podobne jako printf
#define dfmt(s, ...) printf(" - "__FILE__":%u: "s"\n",__LINE__,__VA_ARGS__)

// vypise ladici informaci o promenne - pouziti dint(identifikator_promenne)
#define dint(i) printf(" - " __FILE__ ":%u: " #i " = %d\n", __LINE__, i)

// vypise ladici informaci o promenne typu float - pouziti
// dfloat(identifikator_promenne)
#define dfloat(f) printf(" - " __FILE__ ":%u: " #f " = %g\n", __LINE__, f)

#endif

/*****************************************************************
 * Deklarace potrebnych datovych typu:
 *
 * TYTO DEKLARACE NEMENTE
 *
 *   struct obj_t - struktura objektu: identifikator a souradnice
 *   struct cluster_t - shluk objektu:
 *      pocet objektu ve shluku,
 *      kapacita shluku (pocet objektu, pro ktere je rezervovano
 *          misto v poli),
 *      ukazatel na pole shluku.
 */

struct obj_t {
    int id;
    float x;
    float y;
};

struct cluster_t {
    int size;
    int capacity;
    struct obj_t *obj;
};

/*****************************************************************
 * Deklarace potrebnych funkci.
 *
 * PROTOTYPY FUNKCI NEMENTE
 *
 * IMPLEMENTUJTE POUZE FUNKCE NA MISTECH OZNACENYCH 'TODO'
 *
 */

/*
 Inicializace shluku 'c'. Alokuje pamet pro cap objektu (kapacitu).
 Ukazatel NULL u pole objektu znamena kapacitu 0.
*/
void init_cluster(struct cluster_t *c, int cap)
{
    assert(c != NULL);
    assert(cap >= 0);

    c->size = 0;
    c->capacity = cap;
    c->obj = malloc(sizeof(struct obj_t) * cap);
} 
    

/*
 Odstraneni vsech objektu shluku a inicializace na prazdny shluk.
 */
void clear_cluster(struct cluster_t *c)
{
    free(c->obj);
    assert(c->obj == NULL);
    c->capacity = 0;
    c->size = 0;
}

/// Chunk of cluster objects. Value recommended for reallocation.
const int CLUSTER_CHUNK = 10;

/*
 Zmena kapacity shluku 'c' na kapacitu 'new_cap'.
 */
struct cluster_t *resize_cluster(struct cluster_t *c, int new_cap)
{
    // TUTO FUNKCI NEMENTE
    assert(c);
    assert(c->capacity >= 0);
    assert(new_cap >= 0);

    if (c->capacity >= new_cap)
        return c;

    size_t size = sizeof(struct obj_t) * new_cap;

    void *arr = realloc(c->obj, size);
    if (arr == NULL)
        return NULL;

    c->obj = (struct obj_t*)arr;
    c->capacity = new_cap;
    return c;
}

/*
 Prida objekt 'obj' na konec shluku 'c'. Rozsiri shluk, pokud se do nej objekt
 nevejde.
 */
void append_cluster(struct cluster_t *c, struct obj_t obj)
{
    assert(c);
    assert(obj.x >= 0 && obj.x <= 1000);
    assert(obj.y >= 0 && obj.y <= 1000);

    if (c->size >= c->capacity) {
        resize_cluster(c, c->capacity + 1);
    }
    
    c->obj[c->size] = obj;
    c->size += 1;
}

/*
 Seradi objekty ve shluku 'c' vzestupne podle jejich identifikacniho cisla.
 */
void sort_cluster(struct cluster_t *c);

/*
 Do shluku 'c1' prida objekty 'c2'. Shluk 'c1' bude v pripade nutnosti rozsiren.
 Objekty ve shluku 'c1' budou serazeny vzestupne podle identifikacniho cisla.
 Shluk 'c2' bude nezmenen.
 */
void merge_clusters(struct cluster_t *c1, struct cluster_t *c2)
{
    assert(c1 != NULL);
    assert(c2 != NULL);

    sort_cluster(c1);

    if (c1->size + c2->size > c1->capacity) {
        resize_cluster(c1, c1->size + c2->size);
    }

    for (int i = 0; i < c2->size; i++) {
        append_cluster(c1, c2->obj[i]);
    }
}



/**********************************************************************/
/* Prace s polem shluku */

/*
 Odstrani shluk z pole shluku 'carr'. Pole shluku obsahuje 'narr' polozek
 (shluku). Shluk pro odstraneni se nachazi na indexu 'idx'. Funkce vraci novy
 pocet shluku v poli.
*/
int remove_cluster(struct cluster_t *carr, int narr, int idx)
{
    assert(idx < narr);
    assert(narr > 0);

    clear_cluster(&carr[idx]);

    for (int i = idx; i < narr - 1; i++) {
        carr[i] = carr[i + 1];
    }

    return narr - 1;
}

/*
 Pocita Euklidovskou vzdalenost mezi dvema objekty.
 */
float obj_distance(struct obj_t *o1, struct obj_t *o2)
{
    assert(o1 != NULL);
    assert(o2 != NULL);

    return sqrtf(powf(o1->x - o2->x, 2) + powf(o1->y - o2->y, 2));
}

/*
 Pocita vzdalenost dvou shluku.
*/
float cluster_distance(struct cluster_t *c1, struct cluster_t *c2)
{
    assert(c1 != NULL);
    assert(c1->size > 0);
    assert(c2 != NULL);
    assert(c2->size > 0);

    float distance = 1000.0f; // maximalni vzdalenost 2 clusteru

    for (int i = 0; i < c1->size; i++) {
        for (int j = 0; j < c2->size; j++) {
            float object_distance = obj_distance(&(c1->obj[i]), &(c2->obj[j]));
            if (object_distance < distance) {
                distance = object_distance;
            }
        }
    }

    return distance;

}

/*
 Funkce najde dva nejblizsi shluky. V poli shluku 'carr' o velikosti 'narr'
 hleda dva nejblizsi shluky. Nalezene shluky identifikuje jejich indexy v poli
 'carr'. Funkce nalezene shluky (indexy do pole 'carr') uklada do pameti na
 adresu 'c1' resp. 'c2'.
*/
void find_neighbours(struct cluster_t *carr, int narr, int *c1, int *c2)
{
    assert(narr > 0);

    float distance = 1000.0f; // maximalni vzdalenost 2 clusteru

    for (int i = 0; i < narr; i++) {
        for (int j = 0; j < narr; j++) {
            if (cluster_distance(&(carr[i]), &(carr[j])) < distance && i != j) {

                distance = cluster_distance(&(carr[i]), &(carr[j]));
                *c1 = i;
                *c2 = j;
                
            }
        }
    }
}

// pomocna funkce pro razeni shluku
static int obj_sort_compar(const void *a, const void *b)
{
    // TUTO FUNKCI NEMENTE
    const struct obj_t *o1 = (const struct obj_t *)a;
    const struct obj_t *o2 = (const struct obj_t *)b;
    if (o1->id < o2->id) return -1;
    if (o1->id > o2->id) return 1;
    return 0;
}

/*
 Razeni objektu ve shluku vzestupne podle jejich identifikatoru.
*/
void sort_cluster(struct cluster_t *c)
{
    // TUTO FUNKCI NEMENTE
    qsort(c->obj, c->size, sizeof(struct obj_t), &obj_sort_compar);
}

/*
 Tisk shluku 'c' na stdout.
*/
void print_cluster(struct cluster_t *c)
{
    // TUTO FUNKCI NEMENTE
    for (int i = 0; i < c->size; i++)
    {
        if (i) putchar(' ');
        printf("%d[%g,%g]", c->obj[i].id, c->obj[i].x, c->obj[i].y);
    }
    putchar('\n');
}

/*
 Checks if the passed string consists of only digits
*/
int is_string_number(char * string) {

    for (int i = 0; i < (int) strlen(string) - 1; i++) {
        if (isdigit(string[i]) == 0) {
            return 0;
        }
    }

    return 1;
}

int free_cluster_array(struct cluster_t *clusters, int cluster_amount)
{
    for (int i = 0; i < cluster_amount; i++) {
        clear_cluster(&clusters[i]);
        if (&clusters[i] == NULL) {
            fprintf(stderr, "Could not dealloc cluster.\n");
            return 0;
        }
    }
    free(clusters);

    if (clusters == NULL) {
        fprintf(stderr, "Could not dealloc cluster array.\n");
        return 0;
    } else return 1;

}

void handle_load_failure(FILE * fp, struct cluster_t *clusters, int cluster_amount, char * message) {
    fprintf(stderr, message);
    free_cluster_array(clusters, cluster_amount);
    fclose(fp);
}
/*
 Ze souboru 'filename' nacte objekty. Pro kazdy objekt vytvori shluk a ulozi
 jej do pole shluku. Alokuje prostor pro pole vsech shluku a ukazatel na prvni
 polozku pole (ukalazatel na prvni shluk v alokovanem poli) ulozi do pameti,
 kam se odkazuje parametr 'arr'. Funkce vraci pocet nactenych objektu (shluku).
 V pripade nejake chyby uklada do pameti, kam se odkazuje 'arr', hodnotu NULL.
*/
int load_clusters(char *filename, struct cluster_t **arr)
{
    assert(arr != NULL);
    int cluster_amount = 0;
    char line[100];
    char *count_token;

    FILE * fp = fopen(filename, "r");
    if (fp == NULL) {
        fprintf(stderr, "Invalid filename.\n");
        return 0;
    }

    fgets(line, 99, fp);
    strtok(line, "=");
    count_token = strtok(NULL, "=");
    if (is_string_number(count_token) == 1 && atoi(count_token) >= 1) {
            cluster_amount = atoi(count_token);
    } else {
        fprintf(stderr, "Object count is invalid.\n");
        fclose(fp);
        return 0;
    }

    *arr = malloc(cluster_amount * sizeof(struct cluster_t));
    if (arr == NULL) {
        fprintf(stderr, "Could not allocate memory to the cluster array.\n");
        fclose(fp);
        return 0;
    }

    for (int i = 0; i < cluster_amount; i++) {

        struct cluster_t cluster;
        struct obj_t obj;
         // used to avoid duplicate code;

        fgets(line, 99, fp);
        if (feof(fp) != 0 && i < cluster_amount - 1) {
            // handle unexpected EOF
            handle_load_failure(fp, *arr, i, "Could not read data from the input file.\n");
            return 0;
        }

        char * id_token = strtok(line, " ");
        if (is_string_number(id_token) == 1) {
            obj.id = atoi(id_token);
        } else {
            handle_load_failure(fp, *arr, i, "Invalid ID format.\n");
            return 0;
        }

        char * x_token = strtok(NULL, " ");
        obj.x = atoi(x_token);

        char * y_token = strtok(NULL, " ");
        obj.y = atoi(y_token);

        if (is_string_number(x_token) == 0 || is_string_number(y_token) == 0) {
            handle_load_failure(fp, *arr, i, "Invalid coordinate format.\n");
            return 0;
        } else if (obj.x < 0 || obj.x > 1000 || obj.y < 0 || obj.y > 1000) {
            handle_load_failure(fp, *arr, i, "Coordinates out of allowed range.\n");
            return 0;
        } else if(strtok(NULL, " ") != NULL) {
            handle_load_failure(fp, *arr, i,
             "Invalid object definition or several objects on one line.\n");
            return 0;
        }

        for (int j = 0; j < i; j++) {
            if ((*arr)[j].obj->id == obj.id && i != j) {
                handle_load_failure(fp, *arr, i, "Could not read data from the input file.\n");
                return 0;
            }
        }

        init_cluster(&cluster, 1);
        append_cluster(&cluster, obj);
        (*arr)[i] = cluster;

    }

    fclose(fp);
    return cluster_amount;
}

/*
 Tisk pole shluku. Parametr 'carr' je ukazatel na prvni polozku (shluk).
 Tiskne se prvnich 'narr' shluku.
*/
void print_clusters(struct cluster_t *carr, int narr)
{
    printf("Clusters:\n");
    for (int i = 0; i < narr; i++)
    {
        printf("cluster %d: ", i);
        print_cluster(&carr[i]);
    }
}

/*
 Rozrazeni clusteru do cluster_count clusterů, podle Euklidovske vzdalenosti
 Funkce vraci vyslednou velikost carr.
 'carr' je pole shluku. 'narr' je velikost carr. 'cluster_count' je pozadovana velikost.
*/
int cluster_objects(struct cluster_t *carr, int narr, int cluster_count) 
{

    assert(cluster_count > 0);
    
    int c1_index;
    int c2_index;

    while (narr > cluster_count) {
        find_neighbours(carr, narr, &c1_index, &c2_index);
        merge_clusters(&(carr[c1_index]), &(carr[c2_index]));
        narr = remove_cluster(carr, narr, c2_index);
        sort_cluster(&carr[c1_index]);
    }

    return narr;
}

int main(int argc, char *argv[])
{

    if (argv[1] == NULL) {
        fprintf(stderr, "Filename missing.");
        return 1;
    }

    struct cluster_t * clusters;
    int cluster_amount = load_clusters(argv[1], &clusters);
    if (cluster_amount == 0) {
        return 1;
    }
   
    if (cluster_amount == 0) {
        fprintf(stderr, "Could not load clusters from the input file.\n");
        free_cluster_array(clusters, cluster_amount);
        return 1;
    }

    int desired_cluster_amount = 0;
    if (argc == 2) {
        desired_cluster_amount = 1;
    } else if (argc == 3) {
        desired_cluster_amount = atoi(argv[2]);
        if (desired_cluster_amount == 0 || is_string_number(argv[2]) == 0) {
            fprintf(stderr, "Invalid amount of desired clusters.\n");
            free_cluster_array(clusters, cluster_amount);
            return 1;
        }

    } else {
        fprintf(stderr, "Invalid amount of arguments.\n");
        free_cluster_array(clusters, cluster_amount);
        return 1;
    }

    cluster_amount = cluster_objects(clusters, cluster_amount, desired_cluster_amount);
    print_clusters(clusters, cluster_amount);

    if (free_cluster_array(clusters, cluster_amount) == 0) {
        fprintf(stderr, "Memory could not be unalloc'd.\n");
        return 1;
    }
    
    return 0;
}