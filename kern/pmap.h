#ifndef PMAP_H
#define PMAP_H

#include"inc/memlayout.h"
#include"inc/types.h"
#include"kern/env.h"

extern char bootstacktop[], bootstack[];

extern struct PageInfo *pages;
extern size_t npages;

extern pde_t *kern_pgdir;



/** macros to translate kernel virtual address to physical address, linear address <--> physical address */

/* This macro takes a kernel virtual address -- an address that points above
 * KERNBASE, where the machine's maximum 256MB of physical memory is mapped --
 * and returns the corresponding physical address.  It panics if you pass it a
 * non-kernel virtual address.
 */
#define PADDR(kva) _paddr(kva)

static inline physaddr_t
_paddr(void *kva)
{
	return (physaddr_t)kva - KERNBASE;
}

/* This macro takes a physical address and returns the corresponding kernel
 * virtual address.  It panics if you pass an invalid physical address. */
#define KADDR(pa) _kaddr(pa)

static inline void*
_kaddr(physaddr_t pa)
{
	
	return (void *)(pa + KERNBASE);
}

enum {
	// For page_alloc, zero the returned physical page.
	ALLOC_ZERO = 1<<0,
};

/** private method to translate page index to physical address ,kernel virtual address */

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
	return KADDR(page2pa(pp));
}

// interface

void	mem_init(void);

void	page_init(void);
struct PageInfo *page_alloc(int alloc_flags);
void	page_free(struct PageInfo *pp);
int	page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm);
void	page_remove(pde_t *pgdir, void *va);
struct PageInfo *page_lookup(pde_t *pgdir, void *va, pte_t **pte_store);
void	page_decref(struct PageInfo *pp);

void	tlb_invalidate(pde_t *pgdir, void *va);

int	user_mem_check(struct Env *env, const void *va, size_t len, int perm);
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);


pte_t *pgdir_walk(pde_t *pgdir, const void *va, int create);



#endif