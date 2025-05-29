# https://m680x0.github.io/ref/M68000PM_AD_Rev_1_Programmers_Reference_Manual_1992.html
# Section 8.2 Operation Code Map

# http://goldencrystal.free.fr/M68kOpcodes-v2.3.pdf


from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Generator


class Instruction(ABC):
    @abstractmethod
    def permutations() -> Generator["Instruction"]:
        pass

    def supported() -> bool:
        return True

    @abstractmethod
    def asm(self) -> str:
        pass

    @abstractmethod
    def bytes(self) -> bytes:
        pass


@dataclass
class ORIToCCR(Instruction):
    value: int

    def permutations() -> Generator["ORIToCCR"]:
        yield ORIToCCR(123)

    def supported() -> bool:
        return False

    def asm(self) -> str:
        return f"or.b #{self.value}, %ccr"

    def bytes(self) -> bytes:
        return [0b0000_000_0, 0b00_111_100, 0, self.value]


@dataclass
class ORIToSR(Instruction):
    value: int

    def permutations() -> Generator["ORIToSR"]:
        yield ORIToSR(123)

    def supported() -> bool:
        return True

    def asm(self) -> str:
        return "or.b #0, %sr"

    def bytes(self) -> bytes:
        return [0b0000_000_1, 0b01_111_100, 0, 0]


def instructions() -> Generator[Instruction]:
    classes = [ORIToCCR, ORIToSR]
    for cls in classes:
        for perm in cls.permutations():
            yield perm
